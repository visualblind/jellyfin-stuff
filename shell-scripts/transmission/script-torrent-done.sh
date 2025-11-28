#!/usr/bin/env bash
# Transmission script to move torrent files

#################################################################################
#                     Transmission Environment Variables                        #
#################################################################################

# TR_APP_VERSION - Transmission's short version string, e.g. 4.0.0
# TR_TIME_LOCALTIME
# TR_TORRENT_BYTES_DOWNLOADED - Number of bytes that were downloaded for this torrent
# TR_TORRENT_DIR - Location of the downloaded data
# TR_TORRENT_HASH - The torrent's info hash
# TR_TORRENT_ID
# TR_TORRENT_LABELS - A comma-delimited list of the torrent's labels
# TR_TORRENT_NAME - Name of torrent (not filename)
# TR_TORRENT_PRIORITY - The priority of the torrent (Low is "-1", Normal is "0", High is "1")
# TR_TORRENT_TRACKERS - A comma-delimited list of the torrent's trackers' announce URLs

#################################################################################
#                                   VARIABLES                                   #
#################################################################################

LOGFILE="/YourPath/torrentdone.log"
RSYNC_LOGFILE="/YourPath/torrentdone_rsync.log"
TORRENT_DESTPATH="/PathWhereTorrentsAreCopiedTo/"
TORRENT_PATH="$TR_TORRENT_DIR/$TR_TORRENT_NAME"

#################################################################################
#                                   FUNCTIONS                                   #
#################################################################################

function setup_colors() {
    NC='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
}

#################################################################################
#                                 SCRIPT CONTROL                                #
#################################################################################

# Log script events
function edate
{
  setup_colors
  echo -e "${GREEN}$(date '+%Y-%m-%d %H:%M:%S')    ${CYAN}$1${NC}" >> "$LOGFILE"
}

edate "__________________________NEW TORRENT FILE__________________________"
edate "Transmission version: $TR_APP_VERSION"
edate "Time: $TR_TIME_LOCALTIME"
edate "Torrent name: $TR_TORRENT_NAME"
edate "Directory: $TR_TORRENT_DIR"
edate "Torrent Hash: $TR_TORRENT_HASH"
edate "Torrent ID: $TR_TORRENT_ID"
edate "Downloaded: $TR_TORRENT_BYTES_DOWNLOADED"
edate "Full Torrent Path: $TORRENT_PATH"

# checks whether or not the finished torrent file is associated with sonarr/radarr via
# having a label associated with it and only copy if no labels
if [[ -z "$TR_TORRENT_LABELS" ]]; then
    rsync --recursive --update --times --ignore-existing --progress --human-readable \
    --stats --verbose --log-file="$RSYNC_LOGFILE" -f'+ */' -f '+ *' -f'- .git/' \
    "$TORRENT_PATH" "$TORRENT_DESTPATH"
else
    edate "${GREEN}$TR_TORRENT_NAME${NC} is attached to label: ${ORANGE}$TR_TORRENT_LABELS${NC}"
    exit 1
fi

if [[ $? -eq 0 ]]; then
    edate "${GREEN}Copy success to: ${YELLOW}$TORRENT_DESTPATH${NC}"
    exit 0
else
    edate "${RED}Copy failed to: ${YELLOW}$TORRENT_DESTPATH${NC}"
    exit 1
fi