# 🎮 gameservers

## Counter-Strike: Source Dedicated Server ([`cstrike-srcds`](cstrike-srcds/))

A Docker image running [srcds](https://steamdb.info/app/232330) with minimal configurations, based on [steamcmd:ubuntu-20](https://github.com/steamcmd/docker/blob/master/dockerfiles/ubuntu-20/Dockerfile) (credits to @steamcmd). Server and game files will be runtime-provided to the container, therefore this image should not contain files such as maps, texutres, mods, etc in order to keep it as tidy, unopinionated and copyright-hassle-free as possible. Server runs as non-root, `srcds` user.

A first container's run is expected to download all server files to `/var/lib/srcds/data` using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) and it's subsequent runs are expected to incrementally update those files when/if Steam releases a new server version. It's highly recommended to mount a persistent volume to that path if it happens to recreate a broken container or backing up the data easily. Applying Steam updates should only require to restart or recreate the container instance, without having to rebuild this Docker image.

### Usage

Start the `cstrike-srcds` service in background:

```
docker-compose up -d cstrike-srcds
```

>... or just run the `Start cstrike-srcds server in background` task in Visual Studio Code. 🚀

Start an one-off `cstrike-srcds` service instance in foreground with custom params:

```
docker-compose run --service-ports cstrike-srcds \
    /var/lib/srcds/data/srcds_run \
    -game cstrike \
    +map de_inferno \
    +maxplayers 32
```

With `docker run`:

```
docker run \
    --name cstrike-srcds \
    -v $(pwd):/var/lib/srcds/data \
    -p 27015:27015/tcp \
    -p 27015:27015/udp \
    -p 27020:27020/udp \
    paulomu/cstrike-srcds:latest \
    +hostname "Docker Server"
    [+maxplayers 32...]
```

See: [Command Line Options](https://developer.valvesoftware.com/wiki/Command_Line_Options#Source_Dedicated_Server) and [List of CS:S Cvars](https://developer.valvesoftware.com/wiki/List_of_CS:S_Cvars).

Validating server files:

```
docker-compose run --rm cstrike-srcds \
    gosu srcds steamcmd +runscript /var/lib/srcds/validate_srcds.txt
```

Adding content to the server:

```
docker cp \
    fy_pool_day.bsp \
    cstrike-srcds:/var/lib/srcds/data/cstrike/maps/fy_pool_day.bsp
```

### Networking

List of ports that are required to be open:

- Inbound 27015/TCP: for RCON commands and server query.
- Inbound 27015/UDP: for gameplay traffic.
- Inbound 27020/UDP: for [Source TV](https://developer.valvesoftware.com/wiki/SourceTV), if enabled.

### Known issues/limitations

- SIGINT stops srcds when the container runs in foreground, but not in detached
  mode. Therefore, a container stop command results in timeout = SIGKILL. 
  Dockerfile and docker-compose.yml have the explicit SIGINT config, and the
  docker-entrypoint.sh calls `exec`, which should forward the signal. Not sure
  how to fix this yet.

## License

[MIT license](LICENSE)
