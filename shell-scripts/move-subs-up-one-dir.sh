#!/usr/bin/env bash

# this helps to move subtitle files out of their respective subtitle directory up one level to its movie directory if your structure is like this:

#/mnt/path/to/video-movies
#├── Movie
#│   └── Subs

# this can be ran multiple times to 'walk' the subs up one directory at a time

find /mnt/path/to/video-movies -depth -mindepth 3 -maxdepth 4 -type f \
-ipath '*/sub*' \( -iname '*.srt' -o -iname '*.sub' -o -iname '*.idx' \) \
-execdir mv -v "{}" ./.. \;

