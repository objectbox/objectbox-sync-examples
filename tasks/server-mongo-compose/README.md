# Sync Server and MongoDB with Docker Compose

The Sync Server can be connected to a MongoDB instance to perform bidirectional data-sync.
This example shows how to run the Sync Server and a MongoDB instance with Docker Compose.

## Starting the services

This command initiates the services/containers as described in the [docker-compose.yml](docker-compose.yml) script:

```bash
docker compose up # pass -d for detached mode
```
If necessary, images are first pulled, and then the output should look something like this (followed by the output of the services):

```
✔ Network server-mongo-compose_default         Created
✔ Container mongo                              Created
✔ Container server-mongo-compose-mongo-init-1  Created
✔ Container sync-server                        Created
```

If everything went fine, the following services/ports are available:

- ObjectBox Admin at port `9980`: open http://localhost:9980/ to access the Admin (and activate the trial)
- Sync server at port `9999`: this is the target for Sync clients
- MongoDB at port `27017`. Some notes (see below for details): 
  - Ensure that no local instance is running on this port 
  - Use `mongodb://localhost:27017/?directConnection=true` as a connection string if you want connect from the host.

### User ID troubleshooting

Something is not working due to user/permission errors? Read on, otherwise skip this section.

The Sync Server is run using the current user account to make the database easily accessible to the host.
This is configured in the [docker-compose.yml](docker-compose.yml) for the "sync-server" service using 
`user: "${UID:-1000}:${GID:-1000}"`. However, this may not work on all machines and setups.

--> If your user/group ID is not 1000, please adjust them directly in that file.
Alternatively, you could also comment out the line,
in which case the Sync Server will run as root and create the database directory "objectbox" with root permission.

### Activating debug logs

Debug logs can help identify issues on the Sync Server.
While you can enable them using the Admin UI (on the "Status" page),
it's often preferable to do so via configuration so all debug logs,
including the ones during starting up Sync Server.

In the [docker-compose.yml](docker-compose.yml) in the "sync-server" service's `command` section you can find a line like this: `#  --debug`.
The is the commented out debug flag for the Sync Service:
to enable it, simply delete the `#` character at the beginning of the line.
To actually apply this, restart the Sync Server container via `docker compose up -d --force-recreate sync-server`.
Then, you should already see debug logs (`[DEBUG]`) with `docker compose logs sync-server` from the restarted container. 

## Running the MongoDB server

This example comes with its own MongoDB server, so you don't need to install MongoDB locally.

### Accessing MongoDB

Why do we need to use the connection string `mongodb://localhost:27017/?directConnection=true` to connect to MongoDB?
Although the MongoDB port is forwarded to the host, you cannot connect with the default URL `mongodb://localhost:27017/`.

This is because the [init script](mongo-init.sh) initializes a replica set with a single node "mongo".
This host name matches the "mongo" service in the [docker-compose.yml](docker-compose.yml) file,
but it is only accessible within docker compose.
Thus, if you connect via localhost, MongoDB will redirect you to the "mongo" host defined as a docker compose service.
And that's why you need the `?directConnection=true` parameter to ensure that it is not redirecting. 

### Local MongoDB already running?

If you already have a MongoDB instance running locally, you should first stop it (e.g. `sudo systemctl stop mongod` on Ubuntu).
This will avoid port conflicts like this:

```
Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint mongo (...): failed to bind host port for 0.0.0.0:27017:172.18.0.2:27017/tcp: address already in use
```

Note: If you actually want to use your local MongoDB server, you may prefer the "plain" Docker example without "Compose".
This example is available in the [../server-docker](../server-docker/README.md) directory.

## ObjectBox Database

The ObjectBox database is created inside the "objectbox" subdirectory of this directory.
This is done by the Docker volume mapping `.:/data`,
which mounts the current directory (.) from the host into the container at /data,
allowing the container to access files from your project directory.

To **delete the database** to start fresh, simply delete the "objectbox" directory when the services are down,
e.g. after `docker compose down`.

## Starting over

You want to start with "fresh" databases (MongoDB and ObjectBox)? Something is not working and you want to start over? Run these commands:

```bash
docker compose down --volumes  # All Mongo data gets deleted!
rm -rf objectbox  # Delete the objectbox database directory
docker compose up # Start the services again, all new data 
```

## Documentation

- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)
- [Sync MongoDB Connector](https://sync.objectbox.io/mongodb-sync-connector)

## Appendix: Docker Compose hints

This section contains some commands that may be useful when working with Docker Compose.

### Starting/stopping

Starts services and also streams the outputs of the services to the terminal (Crtl-C to stop):

```bash
docker compose up
```

Detached mode (no output to terminal) that runs the services in the background:

```bash
docker compose up -d
```

Stop everything:

```bash
docker compose down
```

Restart only sync-server (MongoDB keeps running):

```bash
docker compose restart sync-server
```

Stop and **delete all volumes** (including the mongo-data volume):

```bash
docker compose down --volumes  # All Mongo data gets deleted!
```

### View logs

To view logs from the Docker Compose services, you can use the following commands:

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

To continuously follow the logs use `-f` as they are generated:

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
