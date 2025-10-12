#!/bin/bash

set -e

SCRIPT_PATH="./docker-cleanup.sh"

chmod +x "$SCRIPT_PATH"

sudo mkdir -p /var/log
sudo touch /var/log/docker-cleanup.log
sudo chmod 644 /var/log/docker-cleanup.log

CRON_JOB="0 2 1 * * $SCRIPT_PATH >> /var/log/docker-cleanup.log 2>&1"

if ! crontab -l 2>/dev/null | grep -q "docker-cleanup.sh"; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Docker cleanup cron job added successfully"
    echo "Will run monthly on the 1st day at 2:00 AM"
else
    echo "Docker cleanup cron job already exists"
fi

echo "Current crontab entries:"
crontab -l