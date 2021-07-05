#!/bin/sh
set -eux

if [ "$1" = "$SRCDS_DATA/srcds_run" ]; then
    gosu srcds steamcmd +runscript $SRCDS_HOME/update_srcds.txt
    mkdir -p $SRCDS_HOME/.steam/sdk32
    ln -sf $SRCDS_HOME/.steam/steamcmd/linux32/steamclient.so $SRCDS_HOME/.steam/sdk32/steamclient.so
    chown -R srcds:srcds $SRCDS_HOME
    chmod -R 700 $SRCDS_HOME
    cd $SRCDS_DATA
    exec gosu srcds "$@"
fi

exec "$@"
