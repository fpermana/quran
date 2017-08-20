#include "TranslationParser.h"
#include <QDebug>
#include <QSqlQuery>
#include <QTextCodec>
#include <QSqlError>

TranslationParser::TranslationParser(QString &tableName, QSqlDatabase &db, QObject *parent) : QObject(parent)
{
    this->db = db;
    this->tableName = tableName;
}

TranslationParser::~TranslationParser()
{
}

QString TranslationParser::getFilepath() const
{
    return filepath;
}

void TranslationParser::setFilepath(const QString &value)
{
    filepath = value;
}

bool TranslationParser::createTranslationTable()
{
    QSqlQuery *query = new QSqlQuery(db);
    QString createTableString = QString("CREATE TABLE IF NOT EXISTS %1 (`id` int(4) NOT NULL PRIMARY KEY, `sura` int(3) NOT NULL default '0', `aya` int(3) NOT NULL default '0', `text` text NOT NULL, UNIQUE (sura, aya));").arg(tableName);
    bool result = query->exec(createTableString);

    query->clear();
    delete query;

    return result;
}

void TranslationParser::parse()
{
    if(createTranslationTable()) {
        QFile inputFile(filepath);
        if (inputFile.open(QIODevice::ReadOnly))
        {
            QTextStream in(&inputFile);
            in.codec()->setCodecForLocale(QTextCodec::codecForName("UTF-8"));;
            in.setCodec("UTF-8");
            int lineCounter = 0;
            QStringList idList, suraList, ayaList, textList;
            while (!in.atEnd())
            {
                QString line = in.readLine();
                QStringList fieldList = line.split("|");
                if(fieldList.count() == 3) {
                    lineCounter++;
                    idList.append(QString("%1").arg(lineCounter));
                    suraList.append(fieldList.at(0));
                    ayaList.append(fieldList.at(1));
                    textList.append(fieldList.at(2));
                }
                if(lineCounter%15 == 14) {
//                    qDebug() << lineCounter;
                    QSqlQuery *query = new QSqlQuery(db);
                    QString queryString = QString("INSERT OR IGNORE INTO %1 (id, sura, aya, text) values (?, ?, ?, ?)").arg(tableName);
                    query->prepare(queryString);
                    query->addBindValue(idList);
                    query->addBindValue(suraList);
                    query->addBindValue(ayaList);
                    query->addBindValue(textList);

                    if (!query->execBatch()) {
                        qDebug() << query->lastError().text();
                    }
                    else {
                        idList.clear();
                        suraList.clear();
                        ayaList.clear();
                        textList.clear();
                    }
                    query->clear();
                    delete query;
                }
            }

            if(!idList.isEmpty()) {QSqlQuery *query = new QSqlQuery(db);
                QString queryString = QString("INSERT OR IGNORE INTO %1 (id, sura, aya, text) values (?, ?, ?, ?)").arg(tableName);
                query->prepare(queryString);
                query->addBindValue(idList);
                query->addBindValue(suraList);
                query->addBindValue(ayaList);
                query->addBindValue(textList);

                if (!query->execBatch()) {
                    qDebug() << query->lastError().text();
                }
                else {
                    idList.clear();
                    suraList.clear();
                    ayaList.clear();
                    textList.clear();
                }
                query->clear();
                delete query;
            }

            inputFile.close();
        }
    }
    emit parsingFinished();
}
