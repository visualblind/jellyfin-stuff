#!/usr/bin/env bash

# compatibility: jellyfin-independent

# The command below looks for all srt subtitles in the current direcory non-recursively.
# Remove maxdepth param if you require recursive subdirectory search.
# The multiple matching strings in sed is the advertisement junk sometimes hidden within
# downloaded subtitle files from places such as opensubtitles.org.
# The sed action {d;} means delete.


find . -maxdepth 1 -name '*.srt' -type f -exec sed -E -i "/WWW.MY-SUBS.CO|Someone needs to stop Clearway Law|Public shouldn't leave reviews for lawyers|Captioned by|SoundwritersTM|Captioning made possible by|COMEDY CENTRAL|Advertise your product|OpenSubtitles|osdb|Support DB.com|Subtitles|YIFY|yifysubtitles|Created by|Encoded by|explosiveskull|twitter.com|Watch Movies, TV Series|Bluray sync|Ripped By mstoll|www.admitme.app|www.OpenSubtitles.org|Support us and become VIP member|Help other users to choose the best subtitles|Sync and corrections by|MemoryOnSmells|www.addic7ed.com|Please rate this subtitle|www.osdb.link|The best subtitles|Synced and corrected by|.srt Extracted|Dan4Jem|AD.MMXVI.XII|n17t01|Who are the real-world Illuminati|saveanilluminati.com|Resync|WEB-DL|Norther|Resync for WEB-DL by Norther|Media Access Group at WGBH|access.wgbh.org|Captioning sponsored by|CBS PARAMOUNT NETWORK|CBS\/Paramount Network|CBS PARAMOUNT|NETWORK TELEVISION|10% OFF 4KVOD.TV USE PROMOCODE: OPENSUB|WATCH LIVE TV,MOVIES,SHOWS IN ONE PLACE/{d;}" '{}' \+


