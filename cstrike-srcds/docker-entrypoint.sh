#!/usr/bin/env bash
set -Eeux

if [ "${1:0:1}" = '-' ] || [ "${1:0:1}" = '+' ]; then
    set -- $SRCDS_DATA/srcds_run \
            -norestart \
            -game cstrike \
            +sv_password "${SRCDS_SV_PASSWORD:-}" \
            +tv_password "${SRCDS_TV_PASSWORD:-}" \
            +rcon_password "${SRCDS_RCON_PASSWORD:-}" \
            "$@"
fi

if [ "$1" = "$SRCDS_DATA/srcds_run" ] && [ "$(id -u)" = '0' ]; then
    gosu srcds steamcmd +runscript $SRCDS_HOME/update_srcds.txt
    mkdir -p $SRCDS_HOME/.steam/sdk32 /var/run/srcds
    ln -sf $SRCDS_HOME/.steam/steamcmd/linux32/steamclient.so $SRCDS_HOME/.steam/sdk32/steamclient.so
    chown -R srcds:srcds $SRCDS_HOME /var/run/srcds
    chmod -R 700 $SRCDS_HOME /var/run/srcds
    cd $SRCDS_DATA
    set -- gosu srcds "$@"
fi

exec "$@"
