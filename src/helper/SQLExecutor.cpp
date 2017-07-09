#include "SQLExecutor.h"
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlQuery>
#include <QRegularExpression>
#include <QDebug>

/**
 * @brief executeQueryFile
 * Read a query file and removes some unnecessary characters/strings such as comments,
 * and executes queries.
 * If there is possible to use Transaction, so this method will uses it.
 * Use this gist as MIT License.
 * EXCEPTION:
 *      Feel free to use this gist as you like without any restriction,
 *      if you or your country are a member of The Axis of Resistance
 *      (Iran + Syria + Lebanon + Russia + Iraq + Yemen + Bahrain + Palestine)
 * ~~ S.M. Mousavi - 2017 ~~
 */
void SQLExecutor::executeQueryFile(QFile &qf, QSqlDatabase &db)
{
    //Read query file content
    qf.open(QIODevice::ReadOnly);
    QString queryStr(qf.readAll());
    qf.close();

    QSqlQuery query(db);

    //Check if SQL Driver supports Transactions
    if(db.driver()->hasFeature(QSqlDriver::Transactions)) {
        //Replace comments and tabs and new lines with space
        queryStr = queryStr.replace(QRegularExpression("(\\/\\*(.|\\n)*?\\*\\/|^--.*\\n|\\t|\\n)", QRegularExpression::CaseInsensitiveOption|QRegularExpression::MultilineOption), " ");
        //Remove waste spaces
        queryStr = queryStr.trimmed();

        //Extracting queries
        QStringList qList = queryStr.split(';', QString::SkipEmptyParts);

        //Initialize regular expression for detecting special queries (`begin transaction` and `commit`).
        //NOTE: I used new regular expression for Qt5 as recommended by Qt documentation.
        QRegularExpression re_transaction("\\bbegin.transaction.*", QRegularExpression::CaseInsensitiveOption);
        QRegularExpression re_commit("\\bcommit.*", QRegularExpression::CaseInsensitiveOption);

        //Check if query file is already wrapped with a transaction
        bool isStartedWithTransaction = re_transaction.match(qList.at(0)).hasMatch();
        if(!isStartedWithTransaction)
          db.transaction();     //<=== not wrapped with a transaction, so we wrap it with a transaction.

        //Execute each individual queries
        foreach(const QString &s, qList) {
          if(re_transaction.match(s).hasMatch())    //<== detecting special query
              db.transaction();
          else if(re_commit.match(s).hasMatch())    //<== detecting special query
              db.commit();
          else {
              query.exec(s);                        //<== execute normal query
              if(query.lastError().type() != QSqlError::NoError) {
                  qDebug() << query.lastError().text();
                  db.rollback();                    //<== rollback the transaction if there is any problem
              }
          }
        }
        if(!isStartedWithTransaction)
          db.commit();          //<== ... completing of wrapping with transaction

    //Sql Driver doesn't supports transaction
    } else {

        //...so we need to remove special queries (`begin transaction` and `commit`)
        queryStr = queryStr.replace(QRegularExpression("(\\bbegin.transaction.*;|\\bcommit.*;|\\/\\*(.|\\n)*?\\*\\/|^--.*\\n|\\t|\\n)", QRegularExpression::CaseInsensitiveOption|QRegularExpression::MultilineOption), " ");
        queryStr = queryStr.trimmed();

        //Execute each individual queries
        QStringList qList = queryStr.split(';', QString::SkipEmptyParts);
        foreach(const QString &s, qList) {
          query.exec(s);
          if(query.lastError().type() != QSqlError::NoError) qDebug() << query.lastError().text();
        }
    }
}
