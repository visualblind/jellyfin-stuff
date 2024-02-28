#!/usr/bin/env bash

TCODETMP='/usr/local/jellyfin/config/transcodes'
#isMounted () { findmnt -rn "$TCODETMP" > /dev/null 2>&1; }

FREE=$(df -k --output=avail "$TCODETMP" | tail -n1)

if [[ $FREE -lt 5242880 ]]; then
    # Free space less than 5 GiB
    rm -rf "$TCODETMP/"* > /dev/null 2>&1
else
    # Delete older than 240 minutes
    find "$TCODETMP" -type f -mmin +240 -delete 2>&1
fi
