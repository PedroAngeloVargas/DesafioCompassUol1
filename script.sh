#!/bin/bash
SITE_URL="URL"
DISCORD_WEBHOOK_URL="SEU_WEBHOOK"
SITE_NAME="Projeto Compass"
LOG_FILE="/var/log/meu_script.log"

STATUS_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" "$SITE_URL")

if [[ "$STATUS_CODE" -eq 200 ]]; then

    LOG_MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') - SITE FUNCIONANDO UHULLL :) - Site: $SITE_NAME ($SITE_URL) - Status HTTP: $STATUS_CODE"
    echo "$LOG_MESSAGE" >> "$LOG_FILE"
else

    LOG_MESSAGE="$(date '+%Y-%m-%d %H:%M:%S') - SITE NÃO TA FUNCIONANDO :( - Site: $SITE_NAME ($SITE_URL) - Status HTTP: $STATUS_CODE"
    echo "$LOG_MESSAGE" >> "$LOG_FILE"


    DISCORD_CONTENT="!O site **$SITE_NAME** ($SITE_URL) está fora do ar! Código HTTP: $STATUS_CODE"
    curl -X POST -H 'Content-Type: application/json' \
        -d "{
              \"username\": \"Monitor de Sites\",
              \"content\": \"$DISCORD_CONTENT\"
            }" "$DISCORD_WEBHOOK_URL"
fi