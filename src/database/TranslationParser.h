#ifndef TRANSLATIONPARSER_H
#define TRANSLATIONPARSER_H

#include <QObject>
#include <QSqlDatabase>
#include <QTextStream>
#include <QFile>

class TranslationParser : public QObject
{
    Q_OBJECT
public:
    explicit TranslationParser(QString &tableName, QSqlDatabase &db, QObject *parent = 0);
    ~TranslationParser();

    QString getFilepath() const;
    void setFilepath(const QString &value);

signals:
    void parsingFinished();

public slots:
    void parse();

private:
    bool createTranslationTable();

    QSqlDatabase db;
    QString filepath;
    QString tableName;
};

#endif // TRANSLATIONPARSER_H
