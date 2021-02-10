#!/usr/bin/env bash
inotifywait -m /mnt/pool0/p0ds0smb/temp/ffmpeg -e create -e moved_to |
  while read dir action file; do
    if [[ "$file" =~ .*\.(mp4|mkv) ]]; then
      bash -c "/mnt/pool0/p0ds0smb/visualblind/Documents/Scripts/linux/ffmpeg-transcode-acodec.sh -d /mnt/pool0/p0ds0smb/temp/ffmpeg -w /mnt/pool0/p0ds0smb/temp/ffmpeg/.working | /usr/bin/logger -t 'ffmpeg-inotify-transcode-acodec.sh'";
    fi;
  done