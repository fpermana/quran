#include "PageModel.h"
#include <QDebug>

PageModel::PageModel(QSqlDatabase *db, QObject *parent) : SqlQueryModel(parent)
{
    this->db = db;
}

void PageModel::getPage(const int page)
{
    if(page > 0) {
        setQuery(QString("SELECT * from pages WHERE id = %1 OR id = %2").arg(page).arg(page+1), *db);
        int count = rowCount();
        if(count == 2) {
            QModelIndex index = this->index(0,0);
            int aya1 = data(index,259).toInt();
            int sura1 = data(index,258).toInt();
            index = this->index(1,0);
            int aya2 = data(index,259).toInt();
            int sura2 = data(index,258).toInt();
            qDebug() << roleNames() << sura1 << aya1 << sura2 << aya2;

            setQuery(QString("SELECT * FROM quran_text WHERE id >= (SELECT id FROM quran_text WHERE sura = %1 AND aya = %2) AND id < (SELECT id FROM quran_text WHERE sura = %3 AND aya = %4)").arg(sura1).arg(aya1).arg(sura2).arg(aya2), *db);
            qDebug() << roleNames();
        }
    }
}
