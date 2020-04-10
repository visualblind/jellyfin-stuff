#!/usr/bin/env bash
TEMPDIR=${1:-'/mnt/pool0/p0ds0smb/temp/ffmpeg'}
WORKDIR=${1:-$TEMPDIR'/working'}
declare -a LOG
shopt -s globstar
shopt -u nullglob

usage()
{
    echo "usage: $0 [-d --directory specify the directory to work in | -w --workdir working directory for FFmpeg | -h --help shows this message]"
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )	shift
                                TEMPDIR="$1"
#				export TEMPDIR
								;;
        -w | --workdir )	shift
                                WORKDIR="$1"
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

pushd $TEMPDIR
[ -d "$WORKDIR" ] || mkdir "$WORKDIR"
FILENAME=$(find . ! -path "*$(basename "$WORKDIR")/*" -regextype posix-extended -regex '.*.(mkv|mp4)' -print)
if [ -n "$FILENAME" ]; then 
  echo -e "\n***DEBUG***:\n\$TEMPDIR: $TEMPDIR, \$WORKDIR: $WORKDIR\n"
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
# 	args=("-i ${f}" "${args[@]}")
#	args+=("$WORKDIR/$(basename "${f}")")
	echo -e '\nffprobe detected '${AUDIOFORMAT[0]}' in the default audio stream with '${AUDIOFORMAT[1]}' channels\nPreparing to convert audio codec to AAC...\n' ; sleep 1
	echo -e "\n***DEBUG***: ffmpeg ${args[@]}\n"
	ffmpeg "${args[@]}" || break
	echo -e '\nMoving '$WORKDIR/$(basename "${f}")' back to source directory name '$(dirname "${f}")'\n'; sleep 1
	mv -ufv "$WORKDIR/$(basename "${f}")" "$(dirname "${f}")" || break
	fi
  done
  printf '\nProcessed:%s\n'
  for i in "${LOG[@]}"; do echo "$i"; done
 fi