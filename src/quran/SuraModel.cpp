#include "SuraModel.h"

SuraModel::SuraModel(QObject *parent) :
    QObject(parent), m_number(0), m_ayas(0), m_start(0), m_name(""), m_tName(""), m_eName(""), m_type(""), m_order(0), m_rukus(0)
{

}

int SuraModel::number() const
{
    return m_number;
}

int SuraModel::ayas() const
{
    return m_ayas;
}

int SuraModel::start() const
{
    return m_start;
}

QString SuraModel::name() const
{
    return m_name;
}

QString SuraModel::tName() const
{
    return m_tName;
}

QString SuraModel::eName() const
{
    return m_eName;
}

QString SuraModel::type() const
{
    return m_type;
}

int SuraModel::order() const
{
    return m_order;
}

int SuraModel::rukus() const
{
    return m_rukus;
}

void SuraModel::setNumber(int number)
{
    if (m_number == number)
        return;

    m_number = number;
    emit numberChanged(m_number);
}

void SuraModel::setAyas(int ayas)
{
    if (m_ayas == ayas)
        return;

    m_ayas = ayas;
    emit ayasChanged(m_ayas);
}

void SuraModel::setStart(int start)
{
    if (m_start == start)
        return;

    m_start = start;
    emit startChanged(m_start);
}

void SuraModel::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void SuraModel::setTName(QString tName)
{
    if (m_tName == tName)
        return;

    m_tName = tName;
    emit tNameChanged(m_tName);
}

void SuraModel::setEName(QString eName)
{
    if (m_eName == eName)
        return;

    m_eName = eName;
    emit eNameChanged(m_eName);
}

void SuraModel::setType(QString type)
{
    if (m_type == type)
        return;

    m_type = type;
    emit typeChanged(m_type);
}

void SuraModel::setOrder(int order)
{
    if (m_order == order)
        return;

    m_order = order;
    emit orderChanged(m_order);
}

void SuraModel::setRukus(int rukus)
{
    if (m_rukus == rukus)
        return;

    m_rukus = rukus;
    emit rukusChanged(m_rukus);
}
