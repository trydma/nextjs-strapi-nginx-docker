#!/bin/bash

ARGS=("$@")
CONTAINER_ID=${ARGS[0]:-docker-strapi-1}

docker cp ./export-data.tar "$CONTAINER_ID:/strapi"

docker exec -i "$CONTAINER_ID" sh -c "echo 'y' | pnpm run strapi import -f export-data.tar"

echo "Import completed. The export-data.tar file has been copied to the Strapi container."