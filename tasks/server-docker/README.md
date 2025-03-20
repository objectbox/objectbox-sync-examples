# Sync Server Example: using the ObjectBox Docker image

ObjectBox Sync Server is available as a Docker image. To obtain it request a [Sync trial](https://objectbox.io/sync/). We then either provide

- a Docker image, **packaged as a .tar.gz**, that can be loaded with:

    ```shell
    docker load --input ~/Downloads/sync-server.tar
    ```

- a private **DockerHub repository** through which the Sync Server image can be pulled:

    ```shell
    docker pull objectboxio/sync-<customer>:sync-server-<version>
    ```

    > [!NOTE]
    > Make sure you are logged in using the provided credentials using `docker login`.

Once you have added the Docker image, it should be visible in the output of `docker image ls`:

```shell
$ docker image ls
REPOSITORY                          TAG                      IMAGE ID       CREATED        SIZE
objectboxio/sync                    sync-server-2025-02-03   d2a8601dcb71   3 weeks ago    103MB
```

## Setup

Run a container using the Sync server image. Mount the current directory to `/data` in the container  and publish ports `9999` for the Sync protocol and `9980` for Admin:

### Using a JSON configuration file

```bash
# Bash
docker run --rm -it \
    --mount source=sync-server-data,target=/data \
    --publish 127.0.0.1:9999:9999 \
    --publish 127.0.0.1:9980:9980 \
    objectboxio/sync:sync-server-2025-02-03 \
    --conf sync-server-config.json
```

```batch
REM Windows Command Prompt
docker run -it ^
    --user=0 ^
    --mount source=sync-server-data,target=/data ^
    --publish 127.0.0.1:9999:9999 ^
    --publish 127.0.0.1:9980:9980 ^
    objectboxio/sync:sync-server-2025-02-03 ^
    --conf sync-server-config.json
```

### Using command line options



```bash
# Bash
docker run --rm -it \
    --volume "$(pwd):/data" \
    --publish 127.0.0.1:9999:9999 \
    --publish 127.0.0.1:9980:9980 \
    objectboxio/sync:sync-server-2025-02-03 \
    --model /data/objectbox-model.json \
    --unsecured-no-authentication \
    --admin-bind 0.0.0.0:9980
```

```batch
REM Windows Command Prompt
docker run --rm -it ^
    --volume "%cd%:/data" ^
    --publish 127.0.0.1:9999:9999 ^
    --publish 127.0.0.1:9980:9980 ^
    objectboxio/sync:sync-server-2025-02-03 ^
    --model /data/objectbox-model.json ^
    --unsecured-no-authentication ^
    --admin-bind 0.0.0.0:9980
```

## Documentation

- [Get a Sync trial](https://objectbox.io/sync/)
- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)
