#include "FileExtractorWorker.h"

#include <quazip/JlCompress.h>
#include <quazip/quazip.h>
#include <quazip/quazipfile.h>

#include <QDateTime>
#include <QHash>
#include <QTime>

#include <QDebug>

FileExtractorWorker::FileExtractorWorker(QObject *parent) :
    password(""), _isRunning(false), _skipForError(true), createFolder(false), QThread(parent)
{
}

FileExtractorWorker::~FileExtractorWorker()
{
    clean();
}

QString FileExtractorWorker::getPassword() const
{
    return password;
}

void FileExtractorWorker::setPassword(const QString &value)
{
    password = value;
}

void FileExtractorWorker::run()
{
    bool status = true;
    status = startExtracting();
    if(_isRunning) {
        emit finished(status);
    }
    else {
        deleteLater();
    }
}

void FileExtractorWorker::clean()
{
    qDebug() << __FUNCTION__;
    int fileZipListCount = fileZipList.count();
    if(fileZipListCount == 0)
        return;

    QHash<int, QuaZip*>::iterator i;
    for (i = quazipHash.begin(); i != quazipHash.end(); ++i) {
        QuaZip *archive = i.value();
        if(archive->isOpen()) {
            archive->close();
        }
    }
}

QVariantMap FileExtractorWorker::getErrorZipMap() const
{
    return errorZipMap;
}


bool FileExtractorWorker::getCreateFolder() const
{
    return createFolder;
}

void FileExtractorWorker::setCreateFolder(bool value)
{
    createFolder = value;
}


qint64 FileExtractorWorker::getFilesCount() const
{
    return _filesCount;
}

bool FileExtractorWorker::startExtracting()
{
    bool result = true;
    _isRunning = true;
    _filesCount = 0;
    _filesExtracted = 0;
    errorZipMap.clear();
//    QHash<int, QuaZip*> quazipHash;
    quazipHash.clear();

    int fileZipListCount = fileZipList.count();
    if(fileZipListCount == 0)
        return result;

    QVariantMap fileZipMap;
    QString fileZip;
    QStringList destinationList;
    for(int i=0; i<fileZipListCount; i++) {
        if(!_isRunning)
            return false;
        fileZipMap = fileZipList.at(i).toMap();
        fileZip = fileZipMap.value(FILEPATH_KEY).toString();
        destinationList.append(fileZipMap.value(EXTRACT_PATH_KEY, "").toString());
        QuaZip *archive = new QuaZip(fileZip);
        if (!archive->open(QuaZip::mdUnzip)) {
            qDebug() << __FUNCTION__ << QString("Failed to open zip file %1 %2").arg(fileZip).arg(__LINE__);
//            errorZipMap.append(fileZip);
            result = false;
            errorZipMap.insert(fileZip, QVariant());
            continue;
        }
        _filesCount += archive->getEntriesCount();
        quazipHash.insert(i,archive);
    }

//    QString extractedCompleteList;
    QuaZipFileInfo info;
    QuaZipFile file;

    QFile out;
    QString filePath;

    QDir dirOperation;
    QString destination;
    QFileInfo fileInfo;

    if(_filesCount > 0)
        emit progress(_filesExtracted, _filesCount);

    QHash<int, QuaZip*>::iterator i;
    for (i = quazipHash.begin(); i != quazipHash.end(); ++i) {
        if(!_isRunning)
            return false;
        QuaZip *archive = i.value();
        fileZip = archive->getZipName();
        qDebug() << __FUNCTION__ << __LINE__ << fileZip;
//        return false;
        if(!archive->isOpen()) {
            if (!archive->open(QuaZip::mdUnzip)) {
                qDebug("Failed to open zip file %s %s", qPrintable(fileZip), qPrintable(QString::number(__LINE__)));
//                errorZipMap.append(fileZip);
                result = false;
                errorZipMap.insert(fileZip, QVariant());
                continue;
            }
        }
        destination = destinationList.at(i.key());
        if(destination.isEmpty()) {
            fileInfo.setFile(archive->getZipName());
            destination = fileInfo.absolutePath();
            if(createFolder)
                destination.append(QString("/%1").arg(fileInfo.completeBaseName()));
        }

        file.setZip(archive);

        QStringList errorFileList;
        for (bool more = archive->goToFirstFile(); more; more = archive->goToNextFile()) {
            if(!_isRunning)
                return false;

            if (!archive->getCurrentFileInfo(&info)) {
                qDebug("testRead(): getCurrentFileInfo(): %d\n", archive->getZipError());
                result = false;
                errorFileList.append(info.name);
                if(!_skipForError) {
                    errorZipMap.insert(fileZip, errorFileList);
                    return false;
                }
                continue;
            }

            if (password.isEmpty())
                file.open(QIODevice::ReadOnly);
            else
                file.open(QIODevice::ReadOnly, password.toLocal8Bit().constData());

            filePath = QString("%1/%2").arg(destination).arg(info.name);
            if (filePath.endsWith("/")) {
                dirOperation.setPath(filePath);
                if(!dirOperation.exists())
                    dirOperation.mkpath(filePath);
            }
            else {
                /*if(counter++ % 1000 == 0) {
                    errorFileList.append(info.name);
                    errorZipMap.insert(fileZip, errorFileList);
                    continue;
                }*/

                if (file.getZipError() != UNZ_OK) {
                    qDebug("testRead(): file.getFileName(): %d", file.getZipError());
                    result = false;
                    errorFileList.append(info.name);
                    if(!_skipForError) {
                        errorZipMap.insert(fileZip, errorFileList);
                        return false;
                    }
                    continue;
                }

                out.setFileName(filePath);
                QFileInfo fileInfo(filePath);
                dirOperation.setPath(fileInfo.absolutePath());
                if(!dirOperation.exists())
                    dirOperation.mkpath(fileInfo.absolutePath());

                if (!out.open(QIODevice::WriteOnly)) {
                    qDebug("Failed to extract file %s, error %s", qPrintable(out.fileName()), qPrintable(out.errorString()));
                    result = false;
                    errorFileList.append(info.name);
                    if(!_skipForError) {
                        errorZipMap.insert(fileZip, errorFileList);
                        return false;
                    }
                    continue;
                }

                if(file.size() > 52428800)
                {
                    while(!file.atEnd()){
                        QByteArray buff = file.read(65535);
                        if(buff.isEmpty()) {
                            qDebug() << __FUNCTION__ << __LINE__ << "buff.isEmpty()" << info.name;
                            break;
                        }
                        out.write(buff);
                    }
                }
                else
                {
                    QByteArray buff = file.readAll();
                    if(buff.isEmpty()) {
                        qDebug() << __FUNCTION__ << __LINE__ << "buff.isEmpty()" << info.name;
                    }
                    out.write(buff);
                }
                out.close();
            }

            if (file.getZipError() != UNZ_OK) {
                qDebug("testRead(): file.getFileName(): %d", file.getZipError());
                result = false;
                errorFileList.append(info.name);
                if(!_skipForError) {
                    errorZipMap.insert(fileZip, errorFileList);
                    return false;
                }
                continue;
            }

            if (!file.atEnd()) {
                qDebug("testRead(): read all but not EOF");
                result = false;
                errorFileList.append(info.name);
                if(!_skipForError) {
                    errorZipMap.insert(fileZip, errorFileList);
                    return false;
                }
                continue;
            }

            if (file.getZipError() != UNZ_OK) {
                qDebug("testRead(): file.close(): %d", file.getZipError());
                result = false;
                errorFileList.append(info.name);
                if(!_skipForError) {
                    errorZipMap.insert(fileZip, errorFileList);
                    return false;
                }
                continue;
            }

            file.close();

            _filesExtracted++;
            emit progress(_filesExtracted, _filesCount);

//            if(!_isRunning)
//                break;
        }

        archive->close();
    }

    return result;
}

QVariantList FileExtractorWorker::getFileZipList() const
{
    return fileZipList;
}

void FileExtractorWorker::addFileZip(const QVariantMap &value)
{
    fileZipList.append(value);
}

void FileExtractorWorker::setFileZipList(const QVariantList &value)
{
    fileZipList = value;
}

void FileExtractorWorker::clear()
{
    fileZipList.clear();
}

bool FileExtractorWorker::extractZip(const QString &fileZip, const QString &password, const QString &dest) {
    QuaZip *archive = new QuaZip(fileZip);
    if (!archive->open(QuaZip::mdUnzip)) {
        qDebug("Failed to open zip file %s", qPrintable(fileZip));
        return false;
    }

    QString destination = dest;
    QFileInfo fileInfo;
    if(dest.isEmpty()) {
        fileInfo.setFile(archive->getZipName());
        destination = fileInfo.absolutePath();
    }

    QuaZipFileInfo info;
    QuaZipFile file(archive);
    QString filePath;
    QDir dirOperation;
    QFile out;
    for (bool more = archive->goToFirstFile(); more; more = archive->goToNextFile()) {
        if (!archive->getCurrentFileInfo(&info)) {
            qDebug("testRead(): getCurrentFileInfo(): %d\n", archive->getZipError());
            return false;
        }

        if (password.isEmpty())
            file.open(QIODevice::ReadOnly);
        else
            file.open(QIODevice::ReadOnly, password.toLocal8Bit().constData());

        filePath = QString("%1/%2").arg(destination).arg(info.name);
        if (filePath.endsWith("/")) {
            dirOperation.setPath(filePath);
            if(!dirOperation.exists())
                dirOperation.mkpath(filePath);
        }
        else {
            if (file.getZipError() != UNZ_OK) {
                qDebug("testRead(): file.getFileName(): %d", file.getZipError());
                return false;
            }

            out.setFileName(filePath);
            fileInfo.setFile(filePath);
            dirOperation.setPath(fileInfo.absolutePath());
            if(!dirOperation.exists())
                dirOperation.mkpath(fileInfo.absolutePath());

            if (!out.open(QIODevice::WriteOnly)) {
                qDebug("Failed to extract file %s, error %s", qPrintable(out.fileName()),
                                                            qPrintable(out.errorString()));
                return false;
            }

            if(file.size() > 52428800)
            {
                while(!file.atEnd()){
                    QByteArray buff = file.read(65535);
                    if(buff.isEmpty()) {
                        qDebug() << "buff.isEmpty()" << info.name;
                        break;
                    }
                    out.write(buff);
                }
            }
            else
            {
                out.write(file.readAll());
            }
            out.close();
        }

        if (file.getZipError() != UNZ_OK) {
            qDebug("testRead(): file.getFileName(): %d", file.getZipError());\
            return false;
        }

        if (!file.atEnd()) {
            qDebug("testRead(): read all but not EOF");
            return false;
        }

        if (file.getZipError() != UNZ_OK) {
            qDebug("testRead(): file.close(): %d", file.getZipError());
            return false;
        }

        file.close();
    }
    archive->close();

    return true;
}

bool FileExtractorWorker::error()
{
    return !errorZipMap.isEmpty();
}

void FileExtractorWorker::cancel()
{
    _isRunning = false;
//    terminate();
}
