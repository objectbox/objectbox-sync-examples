# Sync Server and MongoDB with Docker Compose

The Sync Server can be connected to a MongoDB instance to perform bidirectional data-sync.
This example shows how to run the Sync Server and a MongoDB instance with Docker Compose:

```bash
docker compose up --build
```

This command initiates the containers/network as described in the `docker-compose.yml` script.
The following services are available once the containers start running:

- ObjectBox Admin at port `9980`: open http://localhost:9980/ to access the Admin (and activate the trial)
- MongoDB at port `27017` (note: ensure that no local instance is running on this port)
- Sync server at port `9999`: this is the target for Sync clients

## Documentation

- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)
- [Sync MongoDB Connector](https://sync.objectbox.io/mongodb-sync-connector)