@echo off

rem Check if version parameter is provided
if "%1"=="" goto noversion
set sync_server_version=%1
goto continue

:noversion
echo Version not given (first parameter to this script). Using default version.
set sync_server_version=2025-03-10

:continue
echo Starting ObjectBox Sync Server version %sync_server_version%
echo Stop the server with Ctrl-C
echo --------------------------------------------------------------------------

docker run -it ^
    --user=0 ^
    --mount source=sync-server-data,target=/data ^
    --publish 127.0.0.1:9999:9999 ^
    --publish 127.0.0.1:9980:9980 ^
    objectboxio/sync:sync-server-%sync_server_version% ^
    --conf sync-server-config.json