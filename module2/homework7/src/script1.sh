#!/usr/bin/bash

THRESHOLD=${DISK_LIMIT}
USAGE=$(df / | grep '/$' | awk '{print $5}' | tr -d '%')
LOG_FILE="/var/log/disk.log"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: / usage is at ${USAGE}%, exceed>
fi