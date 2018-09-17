#!/usr/bin/env bash

LOCAL_EXAMPLE=${PWD}/src/project/settings/local.example.py
LOCAL_SETTINGS=${PWD}/src/project/settings/local.py

install_requirements() {
    pip install -r ${PWD}/requirements/dev.txt
    if [ "$?" != "0" ]; then
        echo "Permission denied: virtualenv is not activated." && exit 1
    fi
}

setup_local_settings() {
    cp ${LOCAL_EXAMPLE} ${LOCAL_SETTINGS}

    SECRET_KEY=$(date +%s | sha256sum | base64 | head -c 32 ; echo)

    echo -n "Database engine (postgres[1], mysql[2], sqlite[3]): " && read _DB_ENGINE
    case "${_DB_ENGINE}" in
        "1")
            DB_ENGINE=django.db.backends.postgresql
            pip install psycopg2-binary
            pip freeze | grep psycopg2 >> ${PWD}/requirements/common.txt
            ;;
        "2")
            DB_ENGINE=django.db.backends.mysql
            pip install mysqlclient
            pip freeze | grep mysqlclient >> ${PWD}/requirements/common.txt
            ;;
        "3")
            DB_ENGINE=django.db.backends.sqlite3
            ;;
    esac

    echo -n "Database name: "         && read DB_NAME
    if [ ${_DB_ENGINE} == "1" ] || [ ${_DB_ENGINE} == "2" ]; then
        echo -n "Database host: "     && read DB_HOST
        echo -n "Database port: "     && read DB_PORT
        echo -n "Database user: "     && read DB_USER
        echo -n "Database password: " && read DB_PASSWORD
    fi

    sed -i "
        s|--SECRET_KEY--|${SECRET_KEY}|;
        s|--DB_ENGINE--|${DB_ENGINE}|;
        s|--DB_NAME--|${DB_NAME}|;
        s|--DB_HOST--|${DB_HOST}|;
        s|--DB_PORT--|${DB_PORT}|;
        s|--DB_USER--|${DB_USER}|;
        s|--DB_PASSWORD--|${DB_PASSWORD}|;" ${LOCAL_SETTINGS}
}

install_requirements
setup_local_settings
