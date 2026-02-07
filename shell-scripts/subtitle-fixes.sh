#!/usr/bin/env bash

# Input your location to search for subtitle files
search_location="/path/to/media"

# Populate array variable (array) with srt files one day or less old (-mmin -1440), remove that part if not needed
# readarray delimiter option (-d) requires Bash v4.4+
readarray -d '' array < <(find "$search_location" -maxdepth 2 -name '*.srt' -mmin -1440 -print0)

for i in "${array[@]}"; do
    echo "✅ Processing file '$i'"
    file_output=$(file "$i")
    if [[ "$file_output" == *"CRLF"* ]]; then
        echo "❌ Converting line endings from Windows (CRLF) to Unix in file '$i'"
        dos2unix --quiet "$i"
    fi
    grep -loZE "GELULA|Resync|Downloaded from|YIFY|YTS|Encoder|Subtitles|Synced by|Ripped by|explosiveskull|twitter.com|Watch Movies, TV Series|Sync and corrections|addic7ed" "$i" | xargs -0 sed -E -i "/GELULA|Resync|Downloaded from|YIFY|YTS|Encoder|Subtitles|Synced by|explosiveskull|twitter.com|Watch Movies, TV Series|Sync and corrections|addic7ed/I{d;}" 2>/dev/null
done
echo "✅ Finished processing all files successfully"

