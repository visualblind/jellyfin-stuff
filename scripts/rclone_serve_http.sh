#!/usr/bin/env bash
screen -dmS rclone-serve-http rclone serve http /path/to/local/media --addr :8081 --read-only --user Username --pass Password
