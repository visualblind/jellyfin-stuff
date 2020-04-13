#!/usr/bin/env bash
find . -depth -maxdepth 2 -regextype posix-extended -regex '.*mkv$|.*mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "{}")' \;
