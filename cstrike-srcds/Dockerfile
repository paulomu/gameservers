# cstrike-srcds
FROM steamcmd/steamcmd:ubuntu-20 AS cstrike-srcds

ENV SRCDS_HOME=/var/lib/srcds
ENV SRCDS_DATA=$SRCDS_HOME/data

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu libtinfo5:i386 libsdl2-2.0-0:i386; \
    rm -rf /var/lib/apt/lists/*; \
    gosu nobody true

RUN set -eux; \
    groupadd -r srcds; \
    useradd -r -g srcds --shell=/bin/bash --home-dir=$SRCDS_HOME srcds; \
    mkdir -p $SRCDS_HOME $SRCDS_DATA; \
    chown -R srcds:srcds $SRCDS_HOME; \
    chmod -R 700 $SRCDS_HOME

COPY update_srcds.txt $SRCDS_HOME
COPY validate_srcds.txt $SRCDS_HOME
COPY docker-entrypoint.sh /usr/local/bin

ENTRYPOINT [ "docker-entrypoint.sh" ]

VOLUME $SRCDS_DATA

EXPOSE 27015/tcp 27015/udp 27020/udp

STOPSIGNAL SIGINT

CMD [ "+map", "de_dust2" ]

# Metamod
FROM cstrike-srcds AS metamod

ARG METAMOD_VERSION=1.11

RUN set -eux; \
    apt-get update; \
    apt-get install -y curl wget; \
    mkdir -p $SRCDS_DATA/cstrike && cd $_; \
    wget -O metamod.tar.gz https://mms.alliedmods.net/mmsdrop/$METAMOD_VERSION/$(curl https://mms.alliedmods.net/mmsdrop/$METAMOD_VERSION/mmsource-latest-linux); \
    tar -zxvf metamod.tar.gz; \
    chown -R srcds:srcds .; \
    chmod -R 700 .; \
    rm -rf /var/lib/apt/lists/* metamod.tar.gz

# Sourcemod
FROM metamod AS sourcemod

ARG SOURCEMOD_VERSION=1.10

RUN set -eux; \
    apt-get update; \
    apt-get install -y curl wget; \
    mkdir -p $SRCDS_DATA/cstrike && cd $_; \
    wget -O sourcemod.tar.gz https://sm.alliedmods.net/smdrop/$SOURCEMOD_VERSION/$(curl https://sm.alliedmods.net/smdrop/$SOURCEMOD_VERSION/sourcemod-latest-linux); \
    tar -zxvf sourcemod.tar.gz; \
    chown -R srcds:srcds .; \
    chmod -R 700 .; \
    rm -rf /var/lib/apt/lists/* sourcemod.tar.gz
