#include "VersionModel.h"
#include "GlobalConstants.h"

VersionModel::VersionModel(QObject *parent) :
    _major(0), _minor(0), _build(0), _revision(0), QObject(parent)
{

}

VersionModel::VersionModel(const QString versionString, QObject *parent) :
    _major(0), _minor(0), _build(0), _revision(0), QObject(parent)
{
    setVersion(versionString);
}

int VersionModel::getMajor() const
{
    return _major;
}

int VersionModel::getMinor() const
{
    return _minor;
}

int VersionModel::getRevision() const
{
    return _revision;
}

int VersionModel::getBuild() const
{
    return _build;
}

int VersionModel::getNumericVersion() const
{
    return _major*1000+_minor;
}

void VersionModel::setVersion(const QString value)
{
    QStringList versionList = value.split(".");
    int versionListCount = versionList.count();
    for(int i=0; i<versionListCount; i++) {
        setVersionValue(i, versionList.at(i));
    }
}

void VersionModel::setVersion(int majorVersion, int minorVersion, int buildNumber, int revisionNumber)
{
    _major = majorVersion;
    _minor = minorVersion;
    _build = buildNumber;
    _revision = revisionNumber;
}

void VersionModel::increaseMajorVersion(const int value)
{
    increaseValue(0, value);
}

void VersionModel::increaseMinorVersion(const int value)
{
    increaseValue(1, value);
}

void VersionModel::setVersionValue(const int index, const QString value)
{
    int intValue = value.toInt();
    switch (index) {
        case 0:
            _major = intValue;
            break;
        case 1:
            _minor = intValue;
            break;
        case 2:
            _build = intValue;
            break;
        case 3:
            _revision = intValue;
            break;
        default:
            break;
    }
}

void VersionModel::increaseValue(const int index, const int value)
{
    switch (index) {
        case 0:
            _major += value;
            break;
        case 1:
            if(_minor >= MAX_MINOR_VERSION) {
                _minor = 0;
                _major++;
            }
            else {
                _minor += value;
            }
            break;
        case 2:
            _build += value;
            break;
        case 3:
            _revision += value;
            break;
        default:
            break;
    }
}

QString VersionModel::toString(const bool simple) const {
    if(simple)
        return QString("%1.%2").arg(_major).arg(_minor);
    return QString("%1.%2.%3.%4").arg(_major).arg(_minor).arg(_build).arg(_revision);
}

bool VersionModel::isEmpty() const
{
    return (_major == 0 && _minor == 0 && _build == 0 && _revision == 0);
}
