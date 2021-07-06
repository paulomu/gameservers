FROM paulomu/cstrike-srcds:latest

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
