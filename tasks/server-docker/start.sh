#!/usr/bin/env bash
set -euo pipefail

# macOS does not have realpath and readlink does not have -f option, so do this instead:
script_dir=$( cd "$(dirname "$0")" ; pwd -P )
cd "$script_dir" # Allow to run the script from any directory

if [[ "$#" -ne "1" ]]; then
  echo "Version not given (first parameter to this script). Using default version."
fi
sync_server_version=${1:-2025-03-10}
echo "Starting ObjectBox Sync Server version $sync_server_version"
echo "Stop the server with Ctrl-C"
echo "--------------------------------------------------------------------------"

docker run --rm -it \
    --volume "$(pwd):/data" \
    --user $UID \
    --publish 127.0.0.1:9999:9999 \
    --publish 127.0.0.1:9980:9980 \
    --entrypoint "pwd" \
    objectboxio/sync:sync-server-${sync_server_version}
#   --conf sync-server-config.json
#          ^ This is default file configuration name, so we can omit it
# Uncomment the next line to enable debug logs:
#    --debug
