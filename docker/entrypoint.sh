#!/usr/bin/env bash

set -e

# == Entrypoint variables == #

LOCAL_SETTINGS_EXAMPLE="${PWD}/src/project/settings/local.example.py"
LOCAL_SETTINGS="${PWD}/src/project/settings/local.py"
MANAGE_FILE="${PWD}/manage.py"
ADDRESS=0.0.0.0:8000

# == Common tools == #

info() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "  -i, --info       -> show available api commands"
    echo "  -s, --run-server -> run development \"manage.py runserver 0.0.0.0:8000\" command"
    echo "   *               -> run any other command"
    exit 0
}

# == Internal tools == #

_wait_for() {
    python docker/wait_for.py --host $1 --port $2
}

_cfg_local_settings() {
    if [ ! -f ${LOCAL_SETTINGS} ]; then
        cp ${LOCAL_SETTINGS_EXAMPLE} ${LOCAL_SETTINGS}
        sed -i "
            s|--SECRET_KEY--|${SECRET_KEY}|
            s|--DB_HOST--|${DB_HOST}|
            s|--DB_PORT--|${DB_PORT}|
            s|--DB_NAME--|${DB_NAME}|
            s|--DB_USER--|${DB_USER}|
            s|--DB_PASSWORD--|${DB_PASSWORD}|;" ${LOCAL_SETTINGS}
    fi
}

_migrate() {
    python ${MANAGE_FILE} migrate --database default
}

_run_server() {
    python ${MANAGE_FILE} runserver ${ADDRESS}
}

# == Command wrappers == #

run_server() {
    _cfg_local_settings
    _wait_for ${DB_HOST} ${DB_PORT}
    _migrate
    _run_server
}

# == Entrypoint == #

if [ "$1" = "" ]; then
    info
else
    case "$1" in
        # common tools
        -i | --info)       info;;
        # runners
        -s | --run-server) run_server;;
        # execute other commands
        *) exec "$@";;
    esac
fi
