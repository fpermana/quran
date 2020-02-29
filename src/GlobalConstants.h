#ifndef GLOBALCONSTANTS_H
#define GLOBALCONSTANTS_H

// SETTINGS
#define SETTINGS_ORGANIZATION               "fpermana"
#define SETTINGS_DOMAIN                     "fpermana.id"
#define SETTINGS_APPLICATION                "sailquran"
#define DB_NAME                             "quran.db"
#define DEFAULT_CONNECTION_NAME             "sailquran"
#define THREAD_CONNECTION_NAME              "sailquran_thread"

#define CURRENT_PAGE_KEY                    "current_page"
#define CURRENT_INDEX_KEY                   "current_index"
#define LAST_INDEX_KEY                      "last_index"
#define FONT_SIZE_KEY                       "font_size"
#define TRANSLATION_FONT_SIZE_KEY           "translation_font_size"
#define FONT_NAME_KEY                       "font_name"
#define FONT_COLOR_KEY                      "font_color"
#define BACKGROUND_COLOR_KEY                "background_color"
#define USE_BACKGROUND_KEY                  "use_background"
#define QURAN_TEXT_KEY                      "quran_text"
#define TRANSLATION_KEY                     "translation"
#define TRANSLATION_LOCALE_KEY              "translation_locale"
#define USE_TRANSLATION_KEY                 "use_translation"
#define DB_VERSION_KEY                      "db_version"

#define DEFAULT_QURAN_TEXT                  "quran_text_original"
#define DEFAULT_TRANSLATION                 "id_indonesian"
#define DEFAULT_FONT_NAME                   "KFGQPC Uthmanic Script HAFS" //from qrc:/fonts/UthmanicHafs1 Ver09.otf
#define DEFAULT_FONT_SIZE                   40
#define DEFAULT_TRANSLATION_FONT_SIZE       20
#define DEFAULT_FONT_COLOR                  "#000000"
#define DEFAULT_BACKGROUND_COLOR            "#ffffff"
#define DEFAULT_USE_BACKGROUND              1
#define DEFAULT_USE_TRANSLATION             1

#define MIN_MAJOR_VERSION                   0
#define MIN_MINOR_VERSION                   0
#define MAX_MINOR_VERSION                   99

#define CURRENT_APP_VERSION                 "1.0"
#define FIRST_RELEASE_APP_VERSION           "0.1"

#define CURRENT_DB_VERSION                 "3"
#define FIRST_RELEASE_DB_VERSION           "0"


// for windows resources.rc
#define VER_FILEVERSION                     0,30,0,0
#define VER_FILEVERSION_STR                 "0.30.0.0\0"

#define VER_PRODUCTVERSION                  0,30,0,0
#define VER_PRODUCTVERSION_STR              "0.30\0"

#define VER_COMPANYNAME_STR                 "fpermana.id"
#define VER_FILEDESCRIPTION_STR             "SailQuran"
#define VER_INTERNALNAME_STR                "sailquran"
#define VER_LEGALCOPYRIGHT_STR              "©2020 fpermana.id"
#define VER_LEGALTRADEMARKS1_STR            ""
#define VER_LEGALTRADEMARKS2_STR            ""
#define VER_ORIGINALFILENAME_STR            "sailquran.exe"
#define VER_PRODUCTNAME_STR                 "SailQUran"

#define VER_COMPANYDOMAIN_STR               "fpermana.id"
#define SETTINGS_DEFAULT_LANGUAGE           "ID"

#endif // GLOBALCONSTANTS_H
