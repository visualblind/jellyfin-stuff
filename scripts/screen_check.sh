#!/usr/bin/env bash
SCREEN_NAME=$(basename "$0")
#exit if running
screen_check () {
if ! [[ $(screen -S "$SCREEN_NAME" -Q select .) ]]; then
     echo "screen is running, exiting..."
     echo "variable SCREEN_NAME = $SCREEN_NAME"
     exit
fi
}
screen_check
