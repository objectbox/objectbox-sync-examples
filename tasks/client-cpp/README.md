# Sync Client Example: using the ObjectBox C++ SDK in a command line application

This example shows how to use the ObjectBox C++ API to create a task-list application using ObjectBox Sync.

## Build and run

Prerequisites are CMake 3.14+ and a C/C++ compiler.

### Build with the provided shell script

From a terminal, you can build and run the example like this (to only build, remove the `--run` flag):

```bash
./build.sh --run
```

* The `./build.sh` also accepts `--clean` as the first argument to clear the build directory before building.

### Build within IDEs (CMake)

If you work with a IDE, you can typically just open each example as a CMake project.
The IDE will setup everything for you.

### Build with CMake

If you prefer to use CMake directly (e.g. on a Windows terminal), you can do so as follows:

```
cmake -S . -B build
cmake --build build
```

And then run the built executable:

```
build/objectbox-examples-... # replace ... with the example name
```

## Using the example

when you start the application, it will first show a list of available commands.
You enter the commands and press enter to execute them.

* `ls` - list all tasks
* `new <task text>` - create a new task
* `done <id>` - mark a task as done
* `exit` - exit the application
* `help` - prints the available commands

**Example:** type "new Buy milk" and hit enter to create a new task.
Then type "ls" and hit enter to see the new task (and any other open tasks).
