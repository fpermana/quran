#include "PageModel.h"
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

PageModel::PageModel(QObject *parent)
{

}

PageModel::PageModel(QSqlDatabase *db, QObject *parent) : SqlQueryModel(parent)
{
    this->db = db;
    page = -1;
}

void PageModel::getAya(const int sura1, const int aya1)
{
    this->sura1 = sura1;
    this->aya1 = aya1;
    type = SingleLine;
    setQuery(QString("SELECT %1.*, %2.text AS translation, bookmarks.mark FROM %1 JOIN %2 ON %1.id = %2.id JOIN bookmarks ON %1.id = bookmarks.id WHERE %1.sura = %3 AND %1.aya = %4").arg(textType).arg(translation).arg(sura1).arg(aya1), *db);
}

void PageModel::getAyas(const int sura1, const int aya1)
{
    this->sura1 = sura1;
    this->aya1 = aya1;
    type = LastPage;
    setQuery(QString("SELECT %1.*, %2.text AS translation, bookmarks.mark FROM %1 JOIN %2 ON %1.id = %2.id JOIN bookmarks ON %1.id = bookmarks.id WHERE %1.id >= (SELECT id FROM %1 WHERE sura = %3 AND aya = %4)").arg(textType).arg(translation).arg(sura1).arg(aya1), *db);
}

void PageModel::getAyas(const int sura1, const int aya1, const int sura2, const int aya2)
{
    this->sura1 = sura1;
    this->aya1 = aya1;
    this->sura2 = sura2;
    this->aya2 = aya2;
    type = NormalPage;
    setQuery(QString("SELECT %1.*, %2.text AS translation, bookmarks.mark FROM %1 JOIN %2 ON %1.id = %2.id JOIN bookmarks ON %1.id = bookmarks.id WHERE %1.id >= (SELECT id FROM %1 WHERE sura = %3 AND aya = %4) AND %1.id < (SELECT id FROM %1 WHERE sura = %5 AND aya = %6)").arg(textType).arg(translation).arg(sura1).arg(aya1).arg(sura2).arg(aya2), *db);
}

void PageModel::setPage(int value)
{
    page = value;
}

int PageModel::getPage() const
{
    return page;
}

void PageModel::setJuz(const QVariantMap &value)
{
    juz = value;
}

void PageModel::setSura(const QVariantMap &value)
{
    sura = value;
}

QString PageModel::getSuraEname() const
{
    return sura.value("ename").toString();
}

QString PageModel::getSuraName() const
{
    return sura.value("name").toString();
}

int PageModel::getSuraId() const
{
    return sura.value("id").toInt();
}

QString PageModel::getJuzName() const
{
    return juz.value("name").toString();
}

int PageModel::getJuzId() const
{
    return juz.value("id").toInt();
}

QString PageModel::getTextType() const
{
    return textType;
}

void PageModel::setTextType(const QString &value)
{
    if(textType == value)
        return;
    textType = value;
}

QString PageModel::getTranslation() const
{
    return translation;
}

void PageModel::setTranslation(const QString &value)
{
    if(translation == value)
        return;
    translation = value;
}

void PageModel::refresh()
{
    if(type == SingleLine) {
        getAya(sura1, aya1);
    }
    else if(type == LastPage) {
        getAyas(sura1, aya1);
    }
    else if(type == NormalPage) {
        getAyas(sura1, aya1, sura2, aya2);
    }
}
