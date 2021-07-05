FROM steamcmd/steamcmd:ubuntu-20

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends gosu libtinfo5:i386 libsdl2-2.0-0:i386; \
    rm -rf /var/lib/apt/lists/*; \
    gosu nobody true

ENV SRCDS_HOME /var/lib/srcds
ENV SRCDS_DATA $SRCDS_HOME/data

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

CMD [ "/var/lib/srcds/data/srcds_run" ]
