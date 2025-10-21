#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$PROJECT_DIR/docker"

echo "Setting up Certbot automatic renewal."

RENEWAL_SCRIPT="$SCRIPT_DIR/renew-certbot.sh"

cat > "$RENEWAL_SCRIPT" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$PROJECT_DIR/docker"
LOG_FILE="$PROJECT_DIR/nginx/logs/certbot-renew.log"

echo "[$(date)] Starting certificate renewal." >> "$LOG_FILE"

cd "$DOCKER_DIR"

if docker compose -f production.compose.yml --env-file .env.production run --rm certbot renew >> "$LOG_FILE" 2>&1; then
    echo "[$(date)] Certificate renewal successful" >> "$LOG_FILE"
    
    if docker compose -f production.compose.yml --env-file .env.production exec nginx nginx -s reload >> "$LOG_FILE" 2>&1; then
        echo "[$(date)] Nginx reloaded successfully" >> "$LOG_FILE"
    else
        echo "[$(date)] ERROR: Failed to reload nginx" >> "$LOG_FILE"
    fi
else
    echo "[$(date)] Certificate renewal completed (certificates may already be fresh)" >> "$LOG_FILE"
fi

echo "[$(date)] Renewal process finished" >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"
EOF

chmod +x "$RENEWAL_SCRIPT"

echo "Created renewal script at: $RENEWAL_SCRIPT"

CRON_JOB="0 */12 * * * $RENEWAL_SCRIPT"

if crontab -l 2>/dev/null | grep -q "$RENEWAL_SCRIPT"; then
    echo "Cron job already exists"
else
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added successfully!"
fi

echo ""
echo "Setup complete!"
echo "Certificates will be renewed automatically twice daily (at 00:00 and 12:00)"
echo "Renewal logs will be saved to: $PROJECT_DIR/nginx/logs/certbot-renew.log"
echo ""
echo "Current cron jobs:"
crontab -l | grep -v "^#" | grep -v "^$"
echo ""
echo "To manually test renewal, run:"
echo "  $RENEWAL_SCRIPT"
echo ""
echo "To view renewal logs:"
echo "  tail -f $PROJECT_DIR/nginx/logs/certbot-renew.log"
echo ""
echo "To remove the cron job:"
echo "  crontab -e  # then delete the line containing 'renew-certbot.sh'"
