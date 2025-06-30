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

## Viewing Logs

To view logs from the Docker Compose services, you can use the following commands:

### View existing logs (up to now)

To view logs from all services (Sync Server and MongoDB):

```bash
docker compose logs
```

Or, view logs only from a specific service:

```bash
# View Sync Server logs
docker compose logs sync-server

# View MongoDB logs
docker compose logs mongo
```

### Follow logs in real-time

To continuously follow the logs as they are generated:

```bash
# Follow all logs
docker compose logs -f

# Follow logs from a specific service
docker compose logs -f sync-server
docker compose logs -f mongo
```

### Log options

View the logs with timestamps:

```bash
docker compose logs --timestamps
```

View a limited number of lines:

```bash
# View the last 100 lines
docker compose logs --tail=100 sync-server
```

Of course, you can also combine options, e.g. show the last 50 logs with timestamps and follow new logs in real-time:

```bash
# Follow the last 50 lines with timestamps
docker compose logs -f --timestamps --tail=50 sync-server
```
