docker run -it ^
    --user=0 ^
    --mount source=sync-server-data,target=/data ^
    --publish 127.0.0.1:9999:9999 ^
    --publish 127.0.0.1:9980:9980 ^
    objectboxio/sync:sync-server-2025-02-03 ^
    --model objectbox-model.json ^
    --unsecured-no-authentication ^
    --admin-bind 0.0.0.0:9980