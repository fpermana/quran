#include "Searching.h"
#include "sqlite/SearchingManager.h"
#include "paging/AyaListModel.h"
#include <QRegExp>
#include <QDebug>

Searching::Searching(QObject *parent) : QObject(parent)
{
}

void Searching::search(const QString keyword, const QString quranText, const QString translation, const int from, const int limit, const int lastId)
{
    SearchingManager *sm = new SearchingManager;
    QList<AyaModel *> result = sm->search(keyword, quranText, translation, from, limit, lastId);
    if(!result.isEmpty()) {
        foreach (AyaModel *a, result) {
            QString originalTranslation = a->translation();
            originalTranslation = this->highlightMatching(originalTranslation, keyword);
            a->setTranslation(originalTranslation);
        }

        AyaListModel *model = new AyaListModel;
        model->setAyaList(result);

        emit found(keyword, model);
    }
    sm->deleteLater();
}

void Searching::searchMore(const QString keyword, const QString quranText, const QString translation, const int from, const int limit, const int lastId)
{
    SearchingManager *sm = new SearchingManager;
    QList<AyaModel *> result = sm->search(keyword, quranText, translation, from, limit, lastId);
    foreach (AyaModel *a, result) {
        QString originalTranslation = a->translation();
        originalTranslation = this->highlightMatching(originalTranslation, keyword);
        a->setTranslation(originalTranslation);
    }
    emit foundMore(result);
    sm->deleteLater();
}

void Searching::searchNew(const QString keyword, const QString quranText, const QString translation, const int from, const int limit, const int lastId)
{
    SearchingManager *sm = new SearchingManager;
    QList<AyaModel *> result = sm->search(keyword, quranText, translation, from, limit, lastId);
    if(!result.isEmpty()) {
        foreach (AyaModel *a, result) {
            QString originalTranslation = a->translation();
            originalTranslation = this->highlightMatching(originalTranslation, keyword);
            a->setTranslation(originalTranslation);
        }

        AyaListModel *model = new AyaListModel;
        model->setAyaList(result);

        emit foundNew(keyword, model);
    }
    sm->deleteLater();
}

QString Searching::highlightMatching(QString haystack, const QString &needle)
{
    if (needle.isEmpty())
        return haystack;
    const QRegExp re{"("+QRegExp::escape(needle)+")", Qt::CaseInsensitive};
    return haystack.replace(re, "<span style=\"background-color: #ECF285\">\\1</span>");
}
