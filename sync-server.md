# Sync Server: using the ObjectBox Docker image

ObjectBox Sync Server is distributed as a Docker image and we assume you Docker is installed on your machine.
Depending on your personal preferences, you can use [Docker Engine](https://docs.docker.com/engine/install/) for the command-line interface (CLI). [Docker Desktop](https://docs.docker.com/desktop/) additionally comes with graphical UI.
In this guide, we stick to the plain Docker CLI, which works with both types.

First, let's pull the trial from [Docker Hub](https://hub.docker.com/r/objectboxio/sync-server-trial):

```shell
docker pull objectboxio/sync-server-trial
```

Now let's confirm that the Sync Server container starts up.
We will skip any configuration for now and just display the version:

```shell
docker run --rm -it objectboxio/sync-server-trial --version
```

You should see something like the following output:

```
001-13:45:21.7756 [INFO ] [SvSyAp] Starting ObjectBox Sync Server version 5 (protocol version: 6, core: 4.3.0-2025-05-27 (SyncServer, http, graphql, admin, tree, dlog, backup, lmdb, SyncMongoDb, Auth, Trial))
Exiting immediately (version flag given)
```

## Congratulations 🎉

You have the ObjectBox Sync Server Docker image in place on your local machine.
Now, let's proceed to the examples, e.g. the [Tasks example](/tasks).

## Addition reading

- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)
