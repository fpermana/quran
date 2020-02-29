#ifndef SURAMODEL_H
#define SURAMODEL_H

#include <QObject>

class SuraModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int number READ number WRITE setNumber NOTIFY numberChanged)
    Q_PROPERTY(int ayas READ ayas WRITE setAyas NOTIFY ayasChanged)
    Q_PROPERTY(int start READ start WRITE setStart NOTIFY startChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString tName READ tName WRITE setTName NOTIFY tNameChanged)
    Q_PROPERTY(QString eName READ eName WRITE setEName NOTIFY eNameChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int order READ order WRITE setOrder NOTIFY orderChanged)
    Q_PROPERTY(int rukus READ rukus WRITE setRukus NOTIFY rukusChanged)
public:
    explicit SuraModel(QObject *parent = nullptr);

    int number() const;
    int ayas() const;
    int start() const;
    QString name() const;
    QString tName() const;
    QString eName() const;
    QString type() const;
    int order() const;
    int rukus() const;

signals:
    void numberChanged(int number);
    void ayasChanged(int ayas);
    void startChanged(int start);
    void nameChanged(QString name);
    void tNameChanged(QString tName);
    void eNameChanged(QString eName);
    void typeChanged(QString type);
    void orderChanged(int order);
    void rukusChanged(int rukus);

public slots:
    void setNumber(int number);
    void setAyas(int ayas);
    void setStart(int start);
    void setName(QString name);
    void setTName(QString tName);
    void setEName(QString eName);
    void setType(QString type);
    void setOrder(int ayas);
    void setRukus(int start);

private:
    int m_number;
    int m_ayas;
    int m_start;
    QString m_name;
    QString m_tName;
    QString m_eName;
    QString m_type;
    int m_order;
    int m_rukus;

};

#endif // SURAMODEL_H
