# Sync Server: using the ObjectBox Docker image

ObjectBox Sync Server is available as a Docker image. To obtain it request a [Sync trial](https://objectbox.io/sync/).
We then provide you with a Docker image file, **packaged as a .tar.gz**, that can be loaded "into Docker" like this:

```shell
# YYYY-MM-DD is the actual date (version) of the image
docker load --input ~/Downloads/YYYY-MM-DD-objectbox-sync-server-docker.tar.gz
```
Note: some older Docker versions might not directly load the tar.gz.
In this case, please extract the tar.gz to produce a .tar file and load that.

<!-- We do not provide this at the moment:
- a private **DockerHub repository** through which the Sync Server image can be pulled:

```shell
docker pull objectboxio/sync-<customer>:sync-server-<version>
```

> [!NOTE]
> Make sure you are logged in using the provided credentials using `docker login`.
-->

## Test the Sync Server Container

Once you have added the Docker image, you can verify its availability via `docker image ls`:

```shell
docker image ls # | grep sync-server
```
This should show a Sync Server image similar to this:

```
REPOSITORY                          TAG                      IMAGE ID       CREATED        SIZE
objectboxio/sync                    sync-server-2025-02-03   d2a8601dcb71   3 weeks ago    103MB
```

Now let's see if the Sync Server container starts up.
We will skip any configuration and just display the help message:

<!-- TODO: change to --version once next version is released -->
```shell
docker run --rm -it objectboxio/sync:sync-server-2025-03-10 --help
```

This should exit immediately after showing the version and the usage information:

```
001-14:25:05.1845 [INFO ] [SvSyAp] Starting ObjectBox Sync Server version 5 (protocol version: 6, core: 4.2.0-2025-03-10 (SyncServer, http, graphql, admin, tree, dlog, cluster, backup, lmdb, SyncMongoDb, Auth))
ObjectBox Sync Server
Usage:
...
```

## Congratulations

Now you have the ObjectBox Sync Server Docker image in place.
Now, you can proceed with the examples.

## Addition reading

- [Get a Sync trial](https://objectbox.io/sync/)
- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)
