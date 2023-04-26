#!/usr/bin/env bash

# compatibility: jellyfin-independant

# edit these variables to point to your public web root and jellyfin media location
nginx_www='/var/www/html'
jf_media='/mnt/mergerfs/media'

if [[ -d "$jf_media" ]]; then
    # directory exists, no need to remount

    # exit script if variable is empty
    [ -z "$nginx_www" ] && { echo 'Error: variable nginx_www is not set or empty'; exit 1; }

    # refresh public text files with media index
    cd "$jf_media"
    find "$jf_media/video-movies" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/movies.txt
    find "$jf_media/video-shows" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/shows.txt
#uncomment if you want to generate directory tree as well
#    tree --noreport -d --charset=en_US.utf8 "$jf_media/video-shows" >> $nginx_www/shows.txt
    find "$jf_media/video-standup" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/standup.txt
    find "$jf_media/video-tennis" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --reverse > $nginx_www/tennis.txt
    find "$jf_media/video-starcraft" -mindepth 1 -maxdepth 1 -type f -printf '%f\n' | sort --reverse > $nginx_www/starcraft.txt
    find "$jf_media/video-tech" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort > $nginx_www/tech.txt
    find "$jf_media/podcasts" -mindepth 1 -maxdepth 2 -type d -printf '%f\n' | sort > $nginx_www/podcasts.txt
#uncomment if you want to generate directory tree as well
#    tree --noreport --charset=en_US.utf8 "$jf_media/podcasts" >> $nginx_www/podcasts.txt
    # sort reversed
    find "$jf_media/video-motogp" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --reverse > $nginx_www/motogp.txt
    find "$jf_media/video-formula1" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --reverse > $nginx_www/formula1.txt
#uncomment if you want to generate directory tree as well
#    tree --noreport --charset=en_US.utf8 "$jf_media/video-formula1" >> $nginx_www/formula1.txt
else
    exit 1

fi

