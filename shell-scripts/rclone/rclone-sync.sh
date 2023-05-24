#!/usr/bin/env bash
# RClone Config file
RCLONE_CONFIG=/root/.config/rclone/rclone.conf
SCREEN_NAME=$(basename "$0" | cut -d '.' -f 1)
BANDWIDTH=${1:-4}

export BANDWIDTH
export RCLONE_CONFIG
export SCREEN_NAME

curl -fsS --retry 3 https://hc-ping.com/Insert_ID /dev/null || wget https://hc-ping.com/Insert_ID -O /dev/null

#exit if running
if ! [[ $(screen -S "$SCREEN_NAME" -Q select .) ]]; then
    echo "$SCREEN_NAME is running, exiting..."
    exit 1
fi

#if [[ $(pidof -x "$0" | wc -w) -gt 2 ]]; then
#    echo "$0 already running"
#    exit
#fi

usage()
{
    echo "usage: rclone-sync-video.sh [-b | --bandwidth specify bandwidth as an integer | -h | --help shows this message]"
}

while [ "$1" != "" ]; do
    case $1 in
        -b | --bandwidth )	shift
                                BANDWIDTH=$1
				export BANDWIDTH
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

screen -dmS $SCREEN_NAME -L -Logfile $HOME/.config/rclone/log/filename.log \
bash -c "rclone sync --bwlimit "$BANDWIDTH"M --progress --checksum --transfers 8 \
--checkers 8 --tpslimit 8 --tpslimit-burst 8 --update --filter-from \
$HOME/.config/rclone/filter-file-video.txt --drive-acknowledge-abuse --drive-use-trash=true \
--log-level INFO --delete-during --log-file $HOME/.config/rclone/log/upload-filename.log \
/path/to/local/media rclone-remote1:dir1/dir2"

screen -S $SCREEN_NAME -X colon "logfile flush 0^M"
