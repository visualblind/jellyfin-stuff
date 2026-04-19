#!/usr/bin/env bash

INPUT_M3U="freetv-iptv-playlist-us-travisflix.m3u"
OUTPUT_M3U="WORKING_freetv-iptv-playlist-us-travisflix.m3u"
TIMEOUT_SECONDS=7
MPV_OPTIONS=(
    "--no-video"
    "--really-quiet"
    "--frames=10" # Play only the first frame/chunk to check connectivity
    "--network-timeout=$TIMEOUT_SECONDS"
)

# --- ANSI escape codes for colors ---
function setup_colors() {
    NC='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
}

# Start with the M3U header in the output file
echo "#EXTM3U" > "$OUTPUT_M3U"

# Initialize a variable to hold the previous EXTINF line
last_extinf=""
setup_colors

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
        echo -e "${YELLOW}Testing URL:${NC} $URL... "

        # Test the URL with mpv, using 'timeout' as a safeguard against hangs
        timeout "$TIMEOUT_SECONDS" mpv "${MPV_OPTIONS[@]}" "$URL" >/dev/null 2>&1
        exit_status=$?

        if [[ "$exit_status" -eq 0 || "$exit_status" -eq 124 ]]; then
            echo -e "✅ ${GREEN}Success (OK)${NC}"
            # Append the previous EXTINF line (if present) and the working URL to the output file
            if [[ -n "$last_extinf" ]]; then
                echo "$last_extinf" >> "$OUTPUT_M3U"
            fi
            echo "$URL" >> "$OUTPUT_M3U"
        else
            echo -e "❌ ${RED}Failure${NC} (Exit status: $exit_status)"
        fi
        # Clear the stored EXTINF line after processing the associated URL
        last_extinf=""
    fi
done < "$INPUT_M3U"
echo "Testing complete. Valid URLs written to $OUTPUT_M3U."
