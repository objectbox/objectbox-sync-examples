# Setting up the Sync Server and MongoDB with Docker-Compose

The Sync-server can be connected to a MongoDB instance to perform bidirectional data-sync. This guide describes on how to setup the Sync-server and a MongoDB instance both running in containers orchestrated with Docker Compose.

## Setup

1. Refer to the [`server-docker`](../server-docker/README.md) sample which describes on how to get a Sync server Docker image and load it in Docker.

2. Once the Sync server image is loaded, execute the following command,

```bash
docker compose up --build
```

This command initiates the containers/network as described in the `docker-compose.yml` script. The following services are available once the containers start running,

- MongoDB at port `27017`
- ObjectBox Admin at port `9980`
- Sync server at port `9999`

## Documentation

- [Get a Sync trial](https://objectbox.io/sync/)
- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)
- [Sync MongoDB Connector](https://sync.objectbox.io/mongodb-sync-connector)