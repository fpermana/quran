#include "PageModel.h"
#include <QDebug>

PageModel::PageModel(QObject *parent)
{

}

PageModel::PageModel(QSqlDatabase *db, QObject *parent) : SqlQueryModel(parent)
{
    this->db = db;
    page = -1;
}

void PageModel::getAyas(const int sura1, const int aya1)
{
    setQuery(QString("SELECT * FROM quran_text WHERE id >= (SELECT id FROM quran_text WHERE sura = %1 AND aya = %2)").arg(sura1).arg(aya1), *db);
}

void PageModel::getAyas(const int sura1, const int aya1, const int sura2, const int aya2)
{
    setQuery(QString("SELECT * FROM quran_text WHERE id >= (SELECT id FROM quran_text WHERE sura = %1 AND aya = %2) AND id < (SELECT id FROM quran_text WHERE sura = %3 AND aya = %4)").arg(sura1).arg(aya1).arg(sura2).arg(aya2), *db);
}

void PageModel::setPage(int value)
{
    page = value;
}

int PageModel::getPage() const
{
    return page;
}
