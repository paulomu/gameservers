FROM paulomu/cstrike-srcds:metamod

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
