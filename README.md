# SailQuran
----

SailQuran is simple Quran reader with basic features such as bookmarking and translations. It is a C++ and Qt Framework app and initially created for Sailfish OS.

With advantages of Qt framework, SailQuran could also be developed to another OS like Android, Linux, Windows OS and also as WebAssembly app.

----
## Usage
1. For development on Sailfish OS, open sailfish/sailquran.pro with [Sailfish SDK](https://sailfishos.org/wiki/Application_SDK#Latest_SDK_Release).
2. For development on other OS open sailquran.pro with [Qt Creator](https://www.qt.io/download).
3. For WebAssembly app, follow instructions here [Qt for WebAssembly](https://doc.qt.io/qt-5/wasm.html) and run

----
    $ cd webassembly
    $ /path/to/qt-wasm/qtbase/bin/qmake
    $ make

----
## Resources
All resources (fonts, Quran texts and translations) are gathered and parsed from [tanzil.net](http://tanzil.net) and [qurandatabase](http://qurandatabase.org/).

----
## changelog
* 24-Feb-2020 restructure project, add bookmarks, search in translation and add more target platforms

----
## Todo
* Finishing QML for Android
* Creating web API server for building with USE_API config
* Finishing QML for WebAssembly
* Add recitations feature
