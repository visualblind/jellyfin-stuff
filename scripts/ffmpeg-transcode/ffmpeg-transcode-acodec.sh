#!/usr/bin/env bash
#
# Author: Travis Runyard
# Date: 04-18-2020
# sysinfo.io

set -e
shopt -s globstar
shopt -u nullglob
# Define variables are indexed array
declare -a FILENAME
declare -a LOG
# Modify TEMPDIR and WORKDIR to suit your needs
TEMPDIR="/mnt/pool0/p0ds0smb/temp/ffmpeg"
WORKDIR="$TEMPDIR/working"
SCRIPT_NAME=$(basename "$0")

usage()
{
  cat 1>&2 <<EOF
Usage: "$SCRIPT_NAME" [options]

-h| --help         Help shows this message.
-d| --directory    Specify the directory to process.
-w| --workdir      Writable working directory for FFmpeg.
                   If you don't specify this option, the
                   subdirectory named "working" will be used
                   within the --directory path or \$TEMPDIR.
EOF
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )	shift
                                TEMPDIR="${1:-$TEMPDIR}"
                                WORKDIR="$WORKDIR"
                                ;;
        -w | --workdir )	shift
                                WORKDIR="${1:-$WORKDIR}"
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

cd $TEMPDIR
echo -e "*** DEBUG ***\n\$TEMPDIR = $TEMPDIR\n\$WORKDIR = $WORKDIR"
[ -d "$WORKDIR" ] || mkdir "$WORKDIR"
# Set field separator to newline
OIFS="$IFS"
IFS=$'\n'
FILENAME=($(find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*\.(mkv|mp4)$' -type f -print))
if [ -n "$FILENAME" ]; then
  for f in "${FILENAME[@]}"; do
    LOG+=("$f")
    AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
  	if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then
      # Build ffmpeg array within the loop to populate variables
      args=(
      -nostdin
      -y
      -i "$f"
      -map 0:v:0
      -map 0:a
      -map 0:s?
      -ac "${AUDIOFORMAT[1]}"
      -ar 48000
      -c:v copy
      -c:a aac
      -c:s copy
      "$WORKDIR/$(basename "$f")"
      )
      echo -e '\n*** DEBUG: ffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream with '${AUDIOFORMAT[1]}' channels\nPreparing to convert audio codec to AAC...' ; sleep 1
      echo -e "\n*** DEBUG: ffmpeg ${args[@]}"
      ffmpeg "${args[@]}" || break
      echo -e '\n*** DEBUG: Moving '$WORKDIR/$(basename "$f")' back to source directory name '$(dirname "$f")''; sleep 1
      mv -ufv "$WORKDIR/$(basename "$f")" "$(dirname "$f")" || break
    fi
  done
  printf '\n*** DEBUG ***\nPROCESSED:%s\n'
  for i in "${LOG[@]}"; do echo "$i"; done
else
  echo -e '\n*** DEBUG: No files to process'
fi