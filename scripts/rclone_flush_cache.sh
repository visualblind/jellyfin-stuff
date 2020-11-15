#! /usr/bin/env sh

# Example #1
kill -SIGHUP $(pgrep -f 'rclone mount rclone_mount1')

# Exmaple #2
kill -SIGHUP $(ps aux | grep 'rclone mount rclone_mount1' | grep -v 'grep' |awk '{ print $2 }')

# Example #3
kill -SIGHUP $(pidof 'rclone')