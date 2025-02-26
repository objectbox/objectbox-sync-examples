# Using the Sync Server from Docker

The Sync Server is available as a Docker image that can be accessed by requesting a [Sync trial](https://objectbox.io/sync/). The team can either provide a,

- Docker image packaged as a **.tar.gz** that can loaded with

    `docker load --input ~/Downloads/sync-server.tar`

- Private DockerHub repository details through which the Sync Server image can be pulled 

    `docker pull objectboxio/sync-<customer>:sync-server-<version>`. 

    Make sure you are logged-in with the agreed credentials using `docker login`. 


Once the Docker image is loaded/pulled, it should be visible in the output of `docker image ls`,

```shell
$ docker image ls
REPOSITORY                          TAG                      IMAGE ID       CREATED        SIZE
objectboxio/sync                    sync-server-2025-02-03   d2a8601dcb71   3 weeks ago    103MB
```

## Passing the configuration in JSON

To persist the ObjectBox database files inside the Sync Server container, we create and attach a volume to a container that contains the model and configuration JSON files,

```batch
REM Windows Batch Script
docker volume create sync-server-data
docker run --rm ^
        --volume %cd%:/src ^
        --volume sync-server-data:/data busybox ^
        cp /src/objectbox-model.json /src/sync-server-config.json /data/
```

```bash
# Bash
docker volume create sync-server-data
docker run --rm \
    --volume "$(pwd):/src" \
    --volume sync-server-data:/data busybox \
    cp /src/objectbox-model.json /src/sync-server-config.json /data/
```

We run the container attaching the `sync-server-data` volume and publishing the required ports,

```batch
REM Windows Batch Script
docker run -it ^
    --user=0 ^
    --mount source=sync-server-data,target=/data ^
    --publish 127.0.0.1:9999:9999 ^
    --publish 127.0.0.1:9980:9980 ^
    objectboxio/sync:sync-server-2025-02-03 ^
    --conf sync-server-config.json
```

```bash
# Bash
docker run --rm -it \
    --mount source=sync-server-data,target=/data \
    --publish 127.0.0.1:9999:9999 \
    --publish 127.0.0.1:9980:9980 \
    objectboxio/sync:sync-server-2025-02-03 \
    --conf sync-server-config.json
```

## Passing the configuration via command line options


To persist the ObjectBox database files inside the Sync Server container, we create and attach a volume to a container that contains the model file,

```batch
REM Windows Batch Script
docker volume create sync-server-data
docker run --rm ^
        --volume %cd%:/src ^
        --volume sync-server-data:/data busybox ^
        cp /src/objectbox-model.json /data/
```

```bash
# Bash
docker volume create sync-server-data
docker run --rm \
    --volume "$(pwd):/src" \
    --volume sync-server-data:/data busybox \
    cp /src/objectbox-model.json /data/
```

We run the container attaching the `sync-server-data` volume and publishing the required ports,

```batch
REM Windows Batch Script
docker run -it ^
    --user=0 ^
    --mount source=sync-server-data,target=/data ^
    --publish 127.0.0.1:9999:9999 ^
    --publish 127.0.0.1:9980:9980 ^
    objectboxio/sync:sync-server-2025-02-03 ^
    --model objectbox-model.json ^
    --unsecured-no-authentication ^
    --admin-bind 0.0.0.0:9980
```

```bash
# Bash
docker run --rm -it \
    --mount source=sync-server-data,target=/data \
    --publish 127.0.0.1:9999:9999 \
    --publish 127.0.0.1:9980:9980 \
    objectboxio/sync:sync-server-2025-02-03 \
    --model objectbox-model.json \
    --unsecured-no-authentication \
    --admin-bind 0.0.0.0:9980
```