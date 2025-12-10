#!/usr/bin/env bash

# Configuration
PLAYLIST_FILE="input.m3u"
TIMEOUT_DURATION=5 # Seconds to wait for a stream to start/run

echo "Starting M3U playlist testing for file: $PLAYLIST_FILE"

# Check if the playlist file exists
if [[ ! -f "$PLAYLIST_FILE" ]]; then
    echo "Error: Playlist file '$PLAYLIST_FILE' not found."
    exit 1
fi

# Loop through each line in the M3U file
while IFS= read -r url
do
    # Skip comment/metadata lines starting with #EXT (standard m3u practice) or just #
    if [[ "$url" =~ ^#.* ]]; then
        continue
    fi

    # Trim leading/trailing whitespace from the URL
    url=$(echo "$url" | xargs)

    if [[ -n "$url" ]]; then
        echo "Testing URL: $url"

        # Run mpv with a timeout, no video, quiet output, and pipe stdout/stderr to null
        # mpv --no-video --really-quiet are used to minimize resource usage and screen output
        # timeout exits with status 124 if the time limit is reached
        #timeout "$TIMEOUT_DURATION" mpv "$url" --no-video
        timeout "$TIMEOUT_DURATION" mpv "$url" --no-video --really-quiet --stop-playback-on-init-failure >/dev/null 2>&1

        EXIT_STATUS=$?

        if [ $EXIT_STATUS -eq 0 ]; then
            echo "  Status: SUCCESS (stream started and ran within $TIMEOUT_DURATION seconds)"
        elif [ $EXIT_STATUS -eq 124 ]; then
            echo "  Status: TIMEOUT (stream is likely long/live and running correctly)"
        else
            echo "  Status: FAILED (mpv exit code: $EXIT_STATUS, likely an error opening the stream)"
        fi
        echo "----------------------------------------------------"
    fi
done < "$PLAYLIST_FILE"

echo "Testing complete."
