#!/bin/bash

ARGS=("$@")
REMOTE_HOST=${ARGS[0]:?Specify user@host for ssh connection}
CONTAINER_ID=${ARGS[1]:-docker-strapi-1}

scp ./export-data.tar "$REMOTE_HOST:/tmp/export-data.tar"

ssh "$REMOTE_HOST" "docker cp /tmp/export-data.tar $CONTAINER_ID:/strapi/export-data.tar"

ssh "$REMOTE_HOST" "docker exec -i $CONTAINER_ID sh -c \"echo 'y' | pnpm run strapi import -f /strapi/export-data.tar\""

ssh "$REMOTE_HOST" "rm -f /tmp/export-data.tar"

echo "Import completed. The export-data.tar file has been imported into the Strapi container."
