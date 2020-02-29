#include "AyaModel.h"

AyaModel::AyaModel(QObject *parent) :
    QObject(parent), m_number(0), m_text(""), m_translation(""), m_sura(0), m_aya(0), m_suraName(""), m_marked(false)
{

}

int AyaModel::number() const
{
    return m_number;
}

QString AyaModel::text() const
{
    return m_text;
}

QString AyaModel::translation() const
{
    return m_translation;
}

int AyaModel::sura() const
{
    return m_sura;
}

int AyaModel::aya() const
{
    return m_aya;
}

QString AyaModel::suraName() const
{
    return m_suraName;
}

bool AyaModel::marked() const
{
    return m_marked;
}

void AyaModel::setNumber(int number)
{
    if (m_number == number)
        return;

    m_number = number;
    emit numberChanged(m_number);
}

void AyaModel::setText(QString text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(m_text);
}

void AyaModel::setTranslation(QString translation)
{
    if (m_translation == translation)
        return;

    m_translation = translation;
    emit translationChanged(m_translation);
}

void AyaModel::setSura(int sura)
{
    if (m_sura == sura)
        return;

    m_sura = sura;
    emit suraChanged(m_sura);
}

void AyaModel::setAya(int aya)
{
    if (m_aya == aya)
        return;

    m_aya = aya;
    emit ayaChanged(m_aya);
}

void AyaModel::setSuraName(QString suraName)
{
    if (m_suraName == suraName)
        return;

    m_suraName = suraName;
    emit suraNameChanged(m_suraName);
}

void AyaModel::setMarked(bool marked)
{
    if (m_marked == marked)
        return;

    m_marked = marked;
    emit markedChanged(m_marked);
}
