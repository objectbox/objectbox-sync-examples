# Copyright 2026 ObjectBox Ltd. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import sys
from cmd import Cmd
from datetime import datetime, timezone
from typing import List

import objectbox
from objectbox import Date, Entity, Id, Store, String, SyncClock, SyncEntity
from objectbox.sync import Sync, SyncChange, SyncChangeListener, SyncCode, SyncCredentials, SyncLoginListener

EPOCH = datetime.fromtimestamp(0, timezone.utc)


# The data model is shared with the other clients and the server: objectbox-model.json (next to this file) contains
# the IDs and UIDs of the entity and its properties, which must match for Sync.
@SyncEntity()
@Entity()
class Task:
    id = Id
    text = String
    date_created = Date
    # If not set (epoch, i.e. the value 0), the task is not finished
    date_finished = Date
    sync_clock = SyncClock


class TaskListApp(Cmd, SyncLoginListener, SyncChangeListener):
    prompt = "$ "

    def __init__(self, store: Store):
        super().__init__()
        self._box = store.box(Task)
        self._query_unfinished = self._box.query(Task.date_finished.equals(0)).build()

    # *** Commands ***

    def do_new(self, text: str):
        if not text:
            print("Missing task text, e.g. new Buy milk", file=sys.stderr)
            return
        task = Task(text=text, date_created=datetime.now(timezone.utc))
        self._box.put(task)
        print(f"New task: {task.id} - {task.text}")

    def do_done(self, arg: str):
        if not arg.isdigit() or int(arg) == 0:
            print(f"Invalid task ID: {arg}", file=sys.stderr)
            return
        task = self._box.get(int(arg))
        if task is None:
            print(f"Task ID {arg} not found", file=sys.stderr)
        elif is_finished(task):
            print(f"Task ID {arg} is already done", file=sys.stderr)
        else:
            task.date_finished = datetime.now(timezone.utc)
            self._box.put(task)
            print(f"Task ID {task.id} marked as done at {format_date(task.date_finished)}")

    def do_ls(self, arg: str):
        if arg == "-a":
            print_tasks(self._box.get_all())
        elif arg == "":
            print_tasks(self._query_unfinished.find())
        else:
            print(f"Unknown ls argument {arg}", file=sys.stderr)

    def do_exit(self, _):
        return True

    def do_EOF(self, _):  # End of input, e.g. Ctrl+D or piped commands
        return True

    def do_help(self, _):
        print("Available commands are:\n"
              "    ls [-a]        list tasks - unfinished or all (-a flag)\n"
              "    new Task text  create a new task with the text 'Task text'\n"
              "    done ID        mark task with the given ID as done\n"
              "    exit           close the program\n"
              "    help           display this help")

    def default(self, line: str):
        print(f"Unknown command {line}", file=sys.stderr)
        self.do_help("")

    def emptyline(self):
        pass  # Cmd would repeat the last command

    # *** Sync listeners: called from the Sync client's background thread ***

    def on_logged_in(self):
        print("Sync client logged in")

    def on_login_failed(self, sync_login_code: SyncCode):
        print(f"Sync client login failed: {sync_login_code.name}", file=sys.stderr)

    def on_change(self, sync_changes: List[SyncChange]):
        print("Task list has changed (synced):")
        print_tasks(self._box.get_all())


def is_finished(task: Task) -> bool:
    return task.date_finished != EPOCH


def format_date(date: datetime) -> str:
    return "" if date == EPOCH else date.astimezone().strftime("%Y-%m-%d %H:%M:%S")


def print_tasks(tasks: List[Task]):
    print(f"{'ID':>4}  {'Created':<20}  {'Finished':<20}  Text")
    for task in tasks:
        print(f"{task.id:>4}  {format_date(task.date_created):<20}  {format_date(task.date_finished):<20}  {task.text}")


def main() -> int:
    parser = argparse.ArgumentParser(description="ObjectBox Sync Python client example (tasks)")
    parser.add_argument("-d", "--directory", default="objectbox",
                        help="database directory; use different ones to run multiple clients (default: objectbox)")
    parser.add_argument("-u", "--url", default="ws://127.0.0.1:9999",
                        help="Sync server URL (default: ws://127.0.0.1:9999)")
    args = parser.parse_args()

    print("** ObjectBox database (https://objectbox.io/) Sync Python client example (tasks). **\n"
          f"Version: {objectbox.version_info()}\n"
          "---------------------------------------------------------------------------------------\n"
          "Check https://objectbox.io/sync for general information on ObjectBox Sync.\n"
          "You can launch multiple instances of this program in parallel in separate windows,\n"
          "each with a separate database by starting with a different `--directory dirname` argument.\n"
          f"The clients automatically connect to the Sync server ({args.url}).\n"
          "See Sync in action: create tasks on one client and refresh the list on the other.\n"
          "Sync docs: https://sync.objectbox.io/ | Python docs: https://docs.objectbox.io/\n"
          "---------------------------------------------------------------------------------------")

    if not Sync.is_available():
        print("Sync is not available in the loaded ObjectBox library: install the package objectbox-sync "
              "(not objectbox), see README.md", file=sys.stderr)
        return 1

    store = Store(directory=args.directory)
    try:
        app = TaskListApp(store)
        # Note: the server is expected to be set up without authentication for this example
        client = Sync.client(store, args.url, SyncCredentials.none())
        client.set_login_listener(app)
        client.set_change_listener(app)
        client.start()  # Connects and syncs in the background

        app.do_help("")
        app.cmdloop()
    finally:
        store.close()  # Also closes the Sync client
    return 0


if __name__ == "__main__":
    sys.exit(main())
