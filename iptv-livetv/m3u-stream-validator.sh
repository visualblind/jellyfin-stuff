#!/usr/bin/env bash

INPUT_M3U="INPUT.m3u"
OUTPUT_M3U="WORKING_STREAMS.m3u"
TIMEOUT_SECONDS=15
MPV_OPTIONS=(
    "--no-video"
    "--really-quiet"
    "--frames=1" # Play only the first frame/chunk to check connectivity
    "--network-timeout=$TIMEOUT_SECONDS"
)

# Start with the M3U header in the output file
echo "#EXTM3U" > "$OUTPUT_M3U"

# Initialize a variable to hold the previous EXTINF line
last_extinf=""

echo "Starting M3U playlist test..."

# Read the input M3U file line by line
while IFS= read -r line; do
    # Remove leading/trailing whitespace
    line=$(echo "$line" | xargs -0)

    if [[ "$line" =~ ^#EXTINF ]]; then
        # Store the EXTINF line
        last_extinf="$line"
    elif [[ -n "$line" && ! "$line" =~ ^# ]]; then
        # This line is likely a URL (and not a comment/empty)
        URL="$line"
        echo -n "Testing URL: "$URL"... "

        # Test the URL with mpv, using 'timeout' as a safeguard against hangs
        timeout "$TIMEOUT_SECONDS" mpv "${MPV_OPTIONS[@]}" "$URL" >/dev/null 2>&1
        exit_status=$?

        if [ $exit_status -eq 0 -o $exit_status -eq 124 ]; then
            echo "Success (OK)"
            # Append the previous EXTINF line (if present) and the working URL to the output file
            if [[ -n "$last_extinf" ]]; then
                echo "$last_extinf" >> "$OUTPUT_M3U"
            fi
            echo "$URL" >> "$OUTPUT_M3U"
        else
            echo "Failure (Exit status: $exit_status)"
        fi
        # Clear the stored EXTINF line after processing the associated URL
        last_extinf=""
    fi
done < "$INPUT_M3U"

echo "Testing complete. Valid URLs written to $OUTPUT_M3U."
