#!/bin/bash

ARGS=("$@")
CONTAINER_ID=${ARGS[0]:-docker-strapi-1}

docker exec "$CONTAINER_ID" pnpm run strapi export --no-encrypt --no-compress -f export-data

docker cp "$CONTAINER_ID:/strapi/export-data.tar" ./

docker exec "$CONTAINER_ID" rm -f export-data.tar

echo "Export completed. The export-data.tar file has been copied to the current directory."