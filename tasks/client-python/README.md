# Sync Client Example: using the ObjectBox Python API in a command line application

This example shows how to use the ObjectBox Python API to create a simple console-based task-list application
using ObjectBox Sync.

## Setup

Prerequisites: Python 3.7 or newer.

ObjectBox Sync requires the Sync variant of the ObjectBox library:
install the package `objectbox-sync` (it provides the module `objectbox`), not `objectbox`.
[requirements.txt](requirements.txt) does this.

```bash
# Enter this directory
cd client-python

# Create a virtual environment and install the dependencies into it
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt   # On Windows: .venv\Scripts\pip install -r requirements.txt

# Run the example
.venv/bin/python main.py                    # On Windows: .venv\Scripts\python main.py
```

Or, with [uv](https://docs.astral.sh/uv/):

```bash
uv venv
uv pip install -r requirements.txt
uv run main.py
```

The example expects a Sync Server running locally (see the [Tasks example README](../README.md)).
Options:

- `--url URL`: the Sync Server URL (default: `ws://127.0.0.1:9999`)
- `--directory DIR`: the database directory (default: `objectbox`);
  use a different one for each instance to run multiple clients on the same machine

## Usage

The application supports the following commands:

```shell
Available commands are:
    ls [-a]        list tasks - unfinished or all (-a flag)
    new Task text  create a new task with the text 'Task text'
    done ID        mark task with the given ID as done
    exit           close the program
    help           display this help
$
```

To create a new task, you can just type `new Buy milk` and hit enter.

Now you can display the list of open tasks by running `ls`:

```shell
  ID  Created               Finished              Text
   1  2026-10-18 14:10:41                         Buy milk
```

To complete a task, you would execute command `done 1` (1 is the ID of the task as shown above).
And to show all tasks, including the finished ones, you can run `ls -a`.

When tasks are changed on another client (and synced via the server), the app prints the updated task list.

## Code overview

Files:

- [main.py](main.py): the example code
- [objectbox-model.json](objectbox-model.json): the data model with its IDs and UIDs, shared with the other clients and
  the server; keep it next to `main.py` (the store looks for it in the directory of the code opening it)
- [requirements.txt](requirements.txt): the dependencies (`objectbox-sync`)

The code:

1. `Task` is the entity class: `@Entity()` defines it for ObjectBox, `@SyncEntity()` enables Sync for it.
   Its `sync_clock` (`SyncClock`) property lets Sync resolve conflicts (last write wins).
2. `main()` opens the store and starts the Sync client via `Sync.client()` and `start()`;
   the client connects and syncs in the background. Closing the store also closes the client.
3. `TaskListApp` is the interactive shell (based on Python's `cmd` module) and the Sync listener:
   - `do_new()` puts a new task (`box.put()`)
   - `do_done()` gets a task (`box.get()`) and puts it with a finish date
   - `do_ls()` lists unfinished tasks (query `Task.date_finished.equals(0)`) or all of them (`box.get_all()`)
   - `on_change()` is called when Sync received changes from the server (from a background thread)

Unfinished tasks have the finish date "epoch start" (value 0), like in the other client examples.

## Changing the data model

The data model must match the server's model (by its IDs and UIDs), so changing it requires the same changes on the
server and the other clients. When you change the `Task` class, ObjectBox updates `objectbox-model.json` when opening
the store: e.g. new properties get new IDs and UIDs. Keep the file under version control.

See [Meta Model, IDs, and UIDs](https://docs.objectbox.io/advanced/meta-model-ids-and-uids) for details.

## Documentation

- [Sync Client](https://sync.objectbox.io/sync-client)
- [ObjectBox Python](https://docs.objectbox.io/) (select Python in the code examples)
- [`objectbox` on PyPI](https://pypi.org/project/objectbox/) and the
  [objectbox-python repository](https://github.com/objectbox/objectbox-python)
