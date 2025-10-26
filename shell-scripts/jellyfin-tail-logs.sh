#!/usr/bin/env bash

# IF JELLYFIN DOES NOT HAVE A TIME ZONE CONFIGURED, JF (AND JF LOGS) WILL RUN ON UNIVERSAL TIME ('-U' TELLS 'DATE' TO USE UTC).
clear; tail -f "/mnt/p10/docker/data/jellyfin/config/log/log_$(date -u +"%Y%m%d").log"

# THE FOLLOWING IS AN EXMAPLE TO SHOW HOW A SHELL OR OPERATOR MAY ALSO WORK:
#tail -f "/directory/jellyfin/config/log/log_$(date +"%Y%m%d" -d "+1 day").log" || tail -f "/directory/jellyfin/config/log/log_$(date +"%Y%m%d").log"
