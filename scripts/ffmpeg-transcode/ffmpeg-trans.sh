#!/usr/bin/env bash
TEMPDIR="/temp/ffmpeg"
WORKDIR="$TEMPDIR/working"
declare -a LOG
shopt -s globstar
shopt -u nullglob

usage()
{
    cat <<EOF
Usage: $(basename "$0") [options]

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
echo -e "DEBUG:\n\$TEMPDIR = $TEMPDIR\n\$WORKDIR = $WORKDIR"
[ -d "$WORKDIR" ] || mkdir "$WORKDIR" || exit $?
FILENAME=$(find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*.(mkv|mp4)' -print)
if [ -n "$FILENAME" ]; then
  for f in $FILENAME; do
  	LOG+=("$f")
	AUDIOFORMAT=($(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "$f"))
  	if ! [ "${AUDIOFORMAT[0]}" = "aac" ]; then

  	# Build ffmpeg array within the loop to populate variables
    args=(
		-i "${f}"
		-map 0:v:0
		-map 0:a:0
		-map 0:s?
		-c:v copy
		-ac "${AUDIOFORMAT[1]}"
		-ar 48000
		-metadata:s:a:0
		language=eng
		-c:a aac
		-c:s copy
		"$WORKDIR/$(basename "${f}")"
		)

	  echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream with '${AUDIOFORMAT[1]}' channels\nPreparing to convert audio codec to AAC...\n' ; sleep 1
    echo -e "\nDEBUG: ffmpeg ${args[@]}\n"
    ffmpeg "${args[@]}" || break
    echo -e '\nMoving '$WORKDIR/$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'; sleep 1
    mv -ufv "$WORKDIR/$(basename "${f}")" "$(dirname "${f}")" || break
    fi
  done
printf '\nPROCESSED:%s\n'
for i in "${LOG[@]}"; do echo "$i"; done
fi