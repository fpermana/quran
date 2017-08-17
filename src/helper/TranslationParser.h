#ifndef TRANSLATIONPARSER_H
#define TRANSLATIONPARSER_H

#include <QObject>

class TranslationParser : public QObject
{
    Q_OBJECT
public:
    explicit TranslationParser(QObject *parent = 0);

signals:

public slots:
};

#endif // TRANSLATIONPARSER_H