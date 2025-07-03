# Sync Server Tasks Example

Starting the ObjectBox Sync Server involves only running a single script.
Additionally, we will show how to verify the setup and how to access the Admin interface.

## Start the Sync Server

The only prerequisite is that you have Docker installed on your machine. Check [sync-server.md](../../sync-server.md) for details.

You can start the Sync Server using the provided start scripts in this directory.

On **Linux/macOS:**, run `./start.sh` (see [start.sh](start.sh)), and on Windows, run `start.bat` (see [start.bat](start.bat)).

Note: by default, the scripts use the "latest" tag of the Docker image.
The scripts also allow specifying the tag to use a specific version, e.g. `./start.sh 2025-06-02`.

When the Sync Server starts, it writes its logs to the console.
You know that the Sync Server is up and running if you the final line looks like this:

```text
001-16:31:07.5507 [INFO ] [SvSyAp] ObjectBox sync server started in 27 ms
```

### Congratulations!

You have successfully started the ObjectBox Sync Server for the "Tasks" example. 🎉

## Admin UI and Trial activation

The Sync Server Admin interface is available at http://127.0.0.1:9980/ in a browser:

<img src="images/sync-server-admin.png" alt="ObjectBox Admin web application" width="500">

## Trial activation

Using the Admin, you can activate the free trial on the [Sync Trial page](http://127.0.0.1:9980/#/sync-trial).
On this page, the trial conditions are explained (e.g. you have 30 days per dataset;
see [this screenshot](images/objectbox-admin-sync-trial.webp) for details).
Once you agree to the terms and register or log in, the Sync Server will be ready to use.

## Admin UI

The Admin allows you to browse data and various information on Sync itself (e.g. statistics and history).
Also, on the "Status" page, it allows you to enable debug logging,
which may be helpful in case you run into problems.
By default, the ObjectBox Sync Server logs only some important information after startup.

For more information,
please refer to the [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration) documentation,
which has a [paragraph on the Admin Web UI](https://sync.objectbox.io/objectbox-sync-server#admin-web-ui).

## Documentation Links

Use the following links to learn more about ObjectBox Sync Server:

- [Get a Sync trial](https://objectbox.io/sync/)
- [Sync Server](https://sync.objectbox.io/objectbox-sync-server)
- [Sync Server Configuration](https://sync.objectbox.io/sync-server-configuration)

## What the start scripts do

To give you some background on the start scripts, this is what they do:

- Run the `docker run` command with appropriate parameters
- Mount the current directory as `/data` in the container
  - Note: `/data` is also the working directory inside the container
  - Makes the configuration `sync-server-config.json` available to the Sync Server
  - Shares the database directory `objectbox`, which is created inside the container
- Publish port 9999 for the Sync protocol on the host machine
- Publish port 9980 for the Admin interface on the host machine

## Verify the Sync Server

Once the Sync Server is up and running, you can verify that its Sync port (9999) is available.
Enter http://127.0.0.1:9999/ in a browser and the result should look like this:

<img src="images/sync-server-verify-sync-port.png" alt="ObjectBox Sync Server is running" width="350">

## ObjectBox Database

The ObjectBox database is created inside the "objectbox" subdirectory of this directory.
This is done by a Docker volume mapping in the scripts, 
which mounts the current directory from the host into the container at /data,
allowing the container to access files from your project directory.

To **delete the database** to start fresh, simply delete the "objectbox" subdirectory when the Docker container is down.

## Adding MongoDB Sync

If you already have the MongoDB connection string, you can add it to the `sync-server-config.json` file like this
(replace the url and database values with your own):

```json
    "mongoDb": {
        "url": "mongodb://localhost:27017",
        "database": "MyDatabase"
    }
```
Then you need to manually trigger one full sync with MongoDB via the Admin UI.
While this may already get you started, we highly recommend checking the [MongoDB connector docs](https://sync.objectbox.io/mongodb-sync-connector) for a full picture.
