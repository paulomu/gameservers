#!/usr/bin/env bash
set -Eeux

if [ "${1:0:1}" = '-' ] || [ "${1:0:1}" = '+' ]; then
    set -- $SRCDS_DATA/srcds_run -game cstrike "$@"
fi

if [ "$1" = "$SRCDS_DATA/srcds_run" ] && [ "$(id -u)" = '0' ]; then
    gosu srcds steamcmd +runscript $SRCDS_HOME/update_srcds.txt
    mkdir -p $SRCDS_HOME/.steam/sdk32
    ln -sf $SRCDS_HOME/.steam/steamcmd/linux32/steamclient.so $SRCDS_HOME/.steam/sdk32/steamclient.so
    chown -R srcds:srcds $SRCDS_HOME
    chmod -R 700 $SRCDS_HOME
    cd $SRCDS_DATA
    exec gosu srcds "$BASH_SOURCE" "$@"
fi

exec "$@"
