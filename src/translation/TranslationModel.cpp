#include "TranslationModel.h"

TranslationModel::TranslationModel(QObject *parent) :
    QObject(parent), m_number(0), m_flag(""), m_lang(""), m_name(""), m_translator(""), m_tid(""), m_installed(false), m_is_default(false), m_visible(false), m_iso6391("")
{

}

int TranslationModel::number() const
{
    return m_number;
}

QString TranslationModel::flag() const
{
    return m_flag;
}

QString TranslationModel::lang() const
{
    return m_lang;
}

QString TranslationModel::name() const
{
    return m_name;
}

QString TranslationModel::translator() const
{
    return m_translator;
}

QString TranslationModel::tid() const
{
    return m_tid;
}

bool TranslationModel::installed() const
{
    return m_installed;
}

bool TranslationModel::isDefault() const
{
    return m_is_default;
}

bool TranslationModel::visible() const
{
    return m_visible;
}

QString TranslationModel::iso6391() const
{
    return m_iso6391;
}

void TranslationModel::setNumber(int number)
{
    if (m_number == number)
        return;

    m_number = number;
    emit numberChanged(m_number);
}

void TranslationModel::setFlag(QString flag)
{
    if (m_flag == flag)
        return;

    m_flag = flag;
    emit flagChanged(m_flag);
}

void TranslationModel::setLang(QString lang)
{
    if (m_lang == lang)
        return;

    m_lang = lang;
    emit langChanged(m_lang);
}

void TranslationModel::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void TranslationModel::setTranslator(QString translator)
{
    if (m_translator == translator)
        return;

    m_translator = translator;
    emit translatorChanged(m_translator);
}

void TranslationModel::setTid(QString tid)
{
    if (m_tid == tid)
        return;

    m_tid = tid;
    emit tidChanged(m_tid);
}

void TranslationModel::setInstalled(bool installed)
{
    if (m_installed == installed)
        return;

    m_installed = installed;
    emit installedChanged(m_installed);
}

void TranslationModel::setIsDefault(bool isDefault)
{
    if (m_is_default == isDefault)
        return;

    m_is_default = isDefault;
    emit isDefaultChanged(m_is_default);
}

void TranslationModel::setVisible(bool visible)
{
    if (m_visible == visible)
        return;

    m_visible = visible;
    emit visibleChanged(m_visible);
}

void TranslationModel::setIso6391(QString iso6391)
{
    if (m_iso6391 == iso6391)
        return;

    m_iso6391 = iso6391;
    emit iso6391Changed(m_iso6391);
}
