#!/usr/bin/env bash
screen -dmS rclone-serve-http rclone serve http /mnt/pool0/p0ds0smb/media --addr :8081 --read-only --user MyUser --pass MyPass
