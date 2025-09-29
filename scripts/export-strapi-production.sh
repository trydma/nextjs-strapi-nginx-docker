#!/bin/bash

ARGS=("$@")
REMOTE_HOST=${ARGS[0]:?Specify user@host for ssh connection}
CONTAINER_ID=${ARGS[1]:-docker-strapi-1}

ssh "$REMOTE_HOST" "docker exec $CONTAINER_ID pnpm run strapi export --no-encrypt --no-compress -f export-data"

ssh "$REMOTE_HOST" "docker cp $CONTAINER_ID:/strapi/export-data.tar /tmp/export-data.tar"

scp "$REMOTE_HOST:/tmp/export-data.tar" ./export-data.tar

ssh "$REMOTE_HOST" "rm -f /tmp/export-data.tar && docker exec $CONTAINER_ID rm -f /strapi/export-data.tar"

echo "Export completed. The export-data.tar file has been copied to the current directory."
