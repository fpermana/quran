#include "TranslationParser.h"
#include <QDebug>

#include <QTextCodec>
#include <QFile>
#ifdef USE_API
#include "api/TranslationManager.h"
#else
#include "sqlite/TranslationManager.h"
#endif

#include "GlobalConstants.h"

TranslationParser::TranslationParser(QObject *parent) : QObject(parent), m_filepath(""), m_tableName("")
{
}

TranslationParser::~TranslationParser()
{
}

QString TranslationParser::getFilepath() const
{
    return m_filepath;
}

void TranslationParser::setFilepath(const QString &value)
{
    m_filepath = value;
}

QString TranslationParser::getTableName() const
{
    return m_tableName;
}

void TranslationParser::setTableName(const QString &tableName)
{
    m_tableName = tableName;
}

void TranslationParser::parse()
{
    qDebug() << __FUNCTION__;
    if(m_tableName.isEmpty() || m_filepath.isEmpty()) {
        emit parsingFinished();
        return;
    }

    bool processFile = true;
    TranslationManager *tm = new TranslationManager(true);
    if(tm->tableExist(m_tableName)) {
        if(tm->rowCount(m_tableName) == tm->rowCount(DEFAULT_QURAN_TEXT)) {
            processFile = false;
        }
    }

    if(tm->createTranslationTable(m_tableName) && processFile) {
        QFile inputFile(m_filepath);
        if (inputFile.open(QIODevice::ReadOnly))
        {
            qDebug() << "reading file" << m_filepath;
            QTextStream in(&inputFile);
            in.codec()->setCodecForLocale(QTextCodec::codecForName("UTF-8"));
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
                if(lineCounter%500 == 499) {
                    qDebug() << lineCounter;

                    if(tm->insertTranslationList(m_tableName, idList, suraList, ayaList, textList)) {
                        idList.clear();
                        suraList.clear();
                        ayaList.clear();
                        textList.clear();
                    }
                }
            }

            if(!idList.isEmpty()) {
                if(tm->insertTranslationList(m_tableName, idList, suraList, ayaList, textList)) {
                    idList.clear();
                    suraList.clear();
                    ayaList.clear();
                    textList.clear();
                }
            }

            inputFile.close();
        }
    }
    else {
        qDebug() << "DB not created";
    }
    tm->deleteLater();
    emit parsingFinished();
}
