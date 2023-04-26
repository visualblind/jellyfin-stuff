#! /usr/bin/env sh

# example #1
kill -SIGHUP $(pgrep -f 'rclone mount rclone_mount1')

# exmaple #2
kill -SIGHUP $(ps aux | grep 'rclone mount rclone_mount1' | grep -v 'grep' |awk '{ print $2 }')

# example #3
kill -SIGHUP $(pidof 'rclone')

