#ifndef TRANSLATIONPARSER_H
#define TRANSLATIONPARSER_H

#include <QObject>

class TranslationParser : public QObject
{
    Q_OBJECT
public:
    explicit TranslationParser(QObject *parent = nullptr);
    ~TranslationParser();

    QString getFilepath() const;
    void setFilepath(const QString &value);

    QString getTableName() const;
    void setTableName(const QString &tableName);

signals:
    void parsingFinished();

public slots:
    void parse();

private:
    QString m_filepath;
    QString m_tableName;
};

#endif // TRANSLATIONPARSER_H
