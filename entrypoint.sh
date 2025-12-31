#!/bin/sh

cp -r /mount/* /host/

dockerd --storage-driver=vfs &
wait $! || exit 1 &
while ! docker info >/dev/null 2>&1; do sleep 1; done

docker compose up --build
