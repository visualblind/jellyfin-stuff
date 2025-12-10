#!/usr/bin/env sh

#If Jellyfin does not have a time zone configured,
#Jellyfin logs will run on UTC.
#To run 'date' on UTC add the '-u' switch.

tail -f "/jellyfin/config/log/log_$(date +%Y%m%d).log"

#Another option is to look at logs with a timestamp
#of tomorrow and failback to todays logs on error.

#tail -f "/jellyfin/config/log/log_$(date +"%Y%m%d" -d "+1 day").log" || tail -f "/jellyfin/config/log/log_$(date +"%Y%m%d").log"