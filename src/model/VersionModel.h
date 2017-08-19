#ifndef VERSIONMODEL_H
#define VERSIONMODEL_H

#include <QObject>
#include <QStringList>
#include <QDebug>

class VersionModel : public QObject
{
    Q_OBJECT
public:
    explicit VersionModel(QObject *parent = 0);
    explicit VersionModel(const QString versionString, QObject *parent = 0);

    int getMajor() const;
    int getMinor() const;
    int getRevision() const;
    int getBuild() const;
    int getNumericVersion() const;

    void setVersion(const QString value);
    void setVersion(int majorVersion, int minorVersion, int buildNumber, int revisionNumber);
    void increaseMajorVersion(const int value = 1);
    void increaseMinorVersion(const int value = 1);

    friend bool operator==(const VersionModel& v1, const VersionModel& v2) {
        return v1.getMajor() == v2.getMajor() && v1.getMinor() == v2.getMinor() && v1.getBuild() == v2.getBuild();
    }
    friend bool operator!=(const VersionModel& v1, const VersionModel& v2) {
        return v1.getMajor() != v2.getMajor() && v1.getMinor() != v2.getMinor() && v1.getBuild() != v2.getBuild();
    }
    friend bool operator>(const VersionModel& v1, const VersionModel& v2) {
        return (v1.getMajor() > v2.getMajor()) || (v1.getMajor() >= v2.getMajor() && v1.getMinor() > v2.getMinor()) || (v1.getMajor() >= v2.getMajor() && v1.getMinor() >= v2.getMinor() &&  v1.getBuild() > v2.getBuild());
    }
    friend bool operator<(const VersionModel& v1, const VersionModel& v2) {
        return (v1.getMajor() < v2.getMajor()) || (v1.getMajor() <= v2.getMajor() && v1.getMinor() < v2.getMinor()) || (v1.getMajor() <= v2.getMajor() && v1.getMinor() <= v2.getMinor() && v1.getBuild() < v2.getBuild());
    }
    friend bool operator>=(const VersionModel& v1, const VersionModel& v2) {
        return (v1.getMajor() >= v2.getMajor()) || (v1.getMajor() >= v2.getMajor() && v1.getMinor() >= v2.getMinor()) || (v1.getMajor() >= v2.getMajor() && v1.getMinor() >= v2.getMinor() && v1.getBuild() >= v2.getBuild());
    }
    friend bool operator<=(const VersionModel& v1, const VersionModel& v2) {
        return (v1.getMajor() <= v2.getMajor()) || (v1.getMajor() <= v2.getMajor() && v1.getMinor() <= v2.getMinor()) || (v1.getMajor() <= v2.getMajor() && v1.getMinor() <= v2.getMinor() && v1.getBuild() <= v2.getBuild());
    }
    friend QDebug operator<<(QDebug dbg, const VersionModel *info){
        dbg << info->toString();
        return dbg;
    }

    QString toString(const bool simple=true) const;
    bool isEmpty() const;

signals:

public slots:

protected:
    int _major;
    int _minor;
    int _revision;
    int _build;

    void setVersionValue(const int index, const QString value);
    void increaseValue(const int index, const int value);
};

#endif // VERSIONMODEL_H
