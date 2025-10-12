#!/bin/bash

set -e

LOG_FILE="/var/log/docker-cleanup.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

log "Starting Docker cleanup process"

log "Removing stopped containers"
docker container prune -f

log "Removing unused networks"
docker network prune -f

log "Removing unused volumes"
docker volume prune -f

log "Removing unused images"
docker image prune -a -f

log "Removing build cache"
docker builder prune -a -f

log "Performing comprehensive system cleanup"
docker system prune -a -f --volumes

log "Docker cleanup completed successfully"
docker system df

log "Docker cleanup process finished"