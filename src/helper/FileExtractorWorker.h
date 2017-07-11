#ifndef FILEEXTRACTORWORKER_H
#define FILEEXTRACTORWORKER_H

#include <QThread>
#include <QVariant>

#ifndef FILEPATH_KEY
#define FILEPATH_KEY    "source"
#endif
#ifndef EXTRACT_PATH_KEY
#define EXTRACT_PATH_KEY    "target"
#endif


class QuaZip;

class FileExtractorWorker : public QThread
{
    Q_OBJECT
public:
    explicit FileExtractorWorker(QObject *parent = 0);
    ~FileExtractorWorker();

    QString getPassword() const;
    void setPassword(const QString &value);

    bool getCreateFolder() const;
    void setCreateFolder(bool value);

    QVariantList getFileZipList() const;
    void addFileZip(const QVariantMap &value);
    void setFileZipList(const QVariantList &value);

    bool startExtracting();

    void clear();
    qint64 getFilesCount() const;

    static bool extractZip(const QString& fileZip, const QString& password = "", const QString& dest = "");
    bool error();

    QVariantMap getErrorZipMap() const;

public slots:
    void cancel();

protected:
    void run();

signals:
    void finished(const bool isOk);
    void progress(const qint64& filesExtracted, const qint64& filesTotal);

private:
    void clean();

    qint64 _filesExtracted, _filesCount;
    QString password;
    bool _isRunning, _skipForError, createFolder;
    QVariantList fileZipList;
    QVariantMap errorZipMap;
    QHash<int, QuaZip*> quazipHash;
};

#endif // FILEEXTRACTORWORKER_H
