#!/usr/bin/env bash
#
# Travis Runyard
# 05-05-2020

# compatibility: jellyfin-independant

# enter your jellyfin transcoding directory
TCODETMP='/usr/local/jellyfin/config/transcodes'

#isMounted () { findmnt -rn "$TCODETMP" > /dev/null 2>&1; }

FREE=$(df -k --output=avail "$TCODETMP" | tail -n1)

if [[ $FREE -lt 10485760 ]]; then
    # Free space less than 10 GiB
    rm -rf "$TCODETMP/*" > /dev/null 2>&1
else
    # Delete older than 200 minutes
    find "$TCODETMP" -type f -mmin +200 -delete 2>&1
fi

