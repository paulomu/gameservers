# Counter-Strike: Source Dedicated Server (`cstrike-srcds`)

## Docker image

[![ci](https://github.com/paulomu/gameservers/actions/workflows/cstrike-srcds.yml/badge.svg)](https://github.com/paulomu/gameservers/actions?query=workflow:%22GitHub%20CI:%20cstrike-srcds%22%20branch:master)

A Docker image running [srcds](https://steamdb.info/app/232330) with minimal configuration, based on [steamcmd:ubuntu-20](https://github.com/steamcmd/docker/blob/master/dockerfiles/ubuntu-20/Dockerfile). Server runs as the non-root `srcds` user.

A first container's boot will download all the server files to `/var/lib/srcds/data` using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD), and it's subsequent runs are expected to incrementally update those files when/if Steam releases a new server version. It's highly recommended to mount a persistent volume to that path, so you can recreate the container as many times you want while keeping the downloaded data. Applying Steam updates should only require you to restart or recreate the container instance, without having to rebuild or pull a newer version of this Docker image.

## Tags

- [`base`, `ubuntu-20`, `latest`](https://github.com/paulomu/gameservers/blob/master/cstrike-srcds/ubuntu-20/Dockerfile): base image
- [`metamod`](https://github.com/paulomu/gameservers/blob/master/cstrike-srcds/metamod/Dockerfile): `base` + [Metamod: Source](https://www.sourcemm.net/about)
- [`sourcemod`](https://github.com/paulomu/gameservers/blob/master/cstrike-srcds/sourcemod/Dockerfile): `metamod` + [SourceMod](https://www.sourcemod.net/about.php)

## Usage

```shell
docker run \
    -it \
    --init \
    --name cstrike-srcds \
    -v cstrike-srcds:/var/lib/srcds/data \
    -p 27015:27015/tcp \
    -p 27015:27015/udp \
    -p 27020:27020/udp \
    paulomu/cstrike-srcds:latest \
    +map de_dust2
```

### Environment variables

- `SRCDS_SV_PASSWORD` (optional): specifies the server password.
- `SRCDS_TV_PASSWORD` (optional): specifies the Source TV client password.
- `SRCDS_RCON_PASSWORD` (optional): specifies the RCON password.

### Common/useful cvars: 

```
+sv_lan <0/1> - If set to 1, server is only available in LAN.
+hostname "Hostname" - Specifies the name of the server (Spaces between words won't work here!).
+maxplayers <number> - Specifies how many player slots the server can contain.
+map <map> - Specifies which map to start.
```

See: [Command Line Options](https://developer.valvesoftware.com/wiki/Command_Line_Options#Source_Dedicated_Server) and [List of CS:S Cvars](https://developer.valvesoftware.com/wiki/List_of_CS:S_Cvars) for srcds args/cvars.

Background (detached) mode: `docker run -dit ...` 

Attach to the srcds console when running in background:

```
docker attach cstrike-srcds
```

>`CTRL-c` quits the srcds process; use `CTRL-p CTRL-q` to detach, or `--detach-keys="<sequence>"` to [override](https://docs.docker.com/engine/reference/commandline/attach/#override-the-detach-sequence) it.

### With docker-compose

Clone this repository, then start the `cstrike-srcds` service in background:

```
docker-compose up -d cstrike-srcds
```

>... or just run the `Start cstrike-srcds server in background` task in Visual Studio Code ([Docker extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) required). 🚀

Start an one-off `cstrike-srcds` service instance in foreground with custom params:

```
docker-compose run --service-ports cstrike-srcds +map de_inferno +maxplayers 32
```

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

## Networking

List of ports that are required to be open:

- Inbound 27015/TCP: for RCON commands and server query.
- Inbound 27015/UDP: for gameplay traffic.
- Inbound 27020/UDP: for [Source TV](https://developer.valvesoftware.com/wiki/SourceTV), if enabled.

## Building images

- Metamod version can be set with `METAMOD_VERSION` arg.
- SourceMod version can be set with `SOURCEMOD_VERSION` arg.

## Known issues/limitations
