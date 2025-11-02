This guide is primarily targeted at those who need to recursively [transcode](https://en.wikipedia.org/wiki/Transcoding) or [remux](https://cloudinary.com/glossary/remuxing) their media using a shell environment.

Strip all subtitles from input file

```bash
# standard
ffmpeg -i inputfile -map 0:v -map 0:a -c:v copy -c:a copy outputfile
# alternatively you can use the '-sn' parameter:
ffmpeg -i inputfile -map 0 -sn -codec copy outputfile
# for loop
for f in *.mkv; do ffmpeg -i "$f" -map 0:v -map 0:a -c:v copy -c:a copy ./working/"${f/.mkv/.x264.mkv}"; done
```

Bash

Copy

Remove chapters if they exist

```bash
# standard
ffmpeg -i inputfile -map_chapters -1 outputfile
# for loop
for f in *.mkv; do ffmpeg -map 0 -map_chapters -1 -codec copy "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

Convert audio stream to AAC and insert subtitles stream from external srt file

```bash
# standard
ffmpeg -i inputfile -f srt -i subtitlefile -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt outputfile
# for loop
# requires subtitle files in same directory as input file with the same base name and srt file extension
for f in *.mkv; do ffmpeg -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v -map 0:a -map 1:0 -c:v copy -c:a aac -c:s srt ./working/"${f/.mkv/.modified.mkv}"; done
```

Bash

Copy

Determine if audio stream is not using AAC codec and transcode into AAC, or not

```bash
for f in *.mkv; do
audioformat=$(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$f")
if [ "$audioformat" = "aac" ]; then
  echo -e '\nffprobe detected aac audio streams\nPreparing to copy english audio stream' ; sleep 4
  ffmpeg -i "$f" -map 0:v:0 -map 0:a:m:language:ger -map 0:a:m:language:eng -map 0:s:m:language:eng -movflags faststart -c:v libx264 -crf 23 -c:a copy -c:s copy "${f/x265/x264}"
  else
  echo -e '\nffprobe detectable audio streams not equal to aac\nPreparing to transcode with aac' ; sleep 4
  ffmpeg -i "$f" -map 0:v:0 -map 0:a:m:language:ger -map 0:a:m:language:eng -map 0:s:m:language:eng -movflags faststart -c:v libx264 -crf 23 -c:a aac -c:s copy "${f/x265/x264}"
fi
done
```

Bash

Copy

Convert 10/8bit HEVC/H.265 to 8bit AVC/H.264 MKV high profile slow preset, insert external SRT subtitle file and not-DEFAULT with English language

```bash
# standard
ffmpeg -y -i inputfile -f srt -i subtitlefile -map 0:v:0 -map 0:a:0 -map 1:0 -movflags faststart -profile:v high -pix_fmt yuv420p -preset slow -disposition:s:0 0 -metadata:s:s:0 language=eng -codec:v libx264 -codec:a copy -codec:s srt outputfile
# for loop
for f in *.mkv; do ffmpeg -y -i "$f" -f srt -i "${f/.mkv/.srt}" -map 0:v:0 -map 0:a:0 -map 1:0 -movflags faststart -profile:v high -pix_fmt yuv420p -preset slow -disposition:s:0 0 -metadata:s:s:0 language=eng -codec:v libx264 -codec:a copy -codec:s srt "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

How to map existing subtitle streams only if they exist

```bash
# standard
ffmpeg -y -i inputfile -map "0:s?" -codec:s copy outputfile
# for loop
for f in *.mkv; do ffmpeg -y -i "$f" -map "0:s?" -codec:s copy "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

Increase volume to 150% of original media

```bash
for f in *.mkv; do ffmpeg -i "$f" -map 0 -filter:a "volume=1.5" -c:v copy -c:a aac -c:s copy "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

Remove all data streams from the container

```bash
ffmpeg -i in.mp4 -c copy -dn -map_metadata:c -1 out.mp4
for f in *.mp4; do ffmpeg -i "$f" -c copy -dn -map_metadata:c -1 "$f"; done
```

Bash

Copy

Remove closed captions (CC)

```bash
ffmpeg -y -i input.mkv -map 0 -c copy -bsf:v "filter_units=remove_types=6" output.mkv
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v -map 0:a -map 0:s? -c:v copy -c:a copy -c:s copy -bsf:v "filter_units=remove_types=6" "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

Insert srt subtitle to mp4

```bash
ffmpeg -i inputfile -i subtitlefile -c:v copy -c:a copy -c:s mov_text outputfile
for f in *.mp4; do ffmpeg -y -i "$f" -i "${f/.mp4/.srt}" -c:v copy -c:a copy -c:s mov_text "${f/.mp4/-modified.mp4}"; done
```

Bash

Copy

Export clean Subrip (SRT) subtitle file without annoying font HTML tagging

```bash
# the trick is to use '-c:s text' instead of '-c:s srt' or '-c:s mov_text' in MP4's
for f in *.mp4; do ffmpeg -y -i "$f" -map 0:s? -c:s text "${f/.mp4/.srt}"; done
```

Bash

Copy

Change Display Aspect Ratio (DAR) in the container

```bash
# Sample Aspect Ratio = (SAR) and Display Aspect Ratio (DAR)
ffmpeg -i input.mp4 -map 0 -aspect 1:1 -codec copy output.mp4
ffmpeg -i input.mkv -map 0 -aspect 2.39 -codec copy output.mkv
```

Bash

Copy

Change the Sample Aspect Ratio (SAR) in the video stream

```bash
ffmpeg -i in.mp4 -c copy -bsf:v "h264_metadata=sample_aspect_ratio=4/3" out.mp4
```

Bash

Copy

Increase max muxing queue size

```bash
ffmpeg -i 'input.mkv' -max_muxing_queue_size 400 'output.mkv'
```

Bash

Copy

Remove subtitle and audio description/title and add english metadata

```bash
for f in *.mkv; do ffmpeg -y -i "$f" -codec copy -metadata:s:a:0 language=eng -metadata:s:a:0 title= -metadata:s:s:0 language=eng -metadata:s:s:0 title= ./working/"${f}"; done
```

Bash

Copy

Add text metadata to various sections of file

```bash
ffmpeg -y -i input.mkv -codec copy -metadata comment="Matroska muxer also accepts free-form key/value metadata pairs" -metadata foo="bar" -metadata description="Matroska muxer description" -metadata:s:v:0 title="Video stream title/description" -metadata:s:a:0 title="Audio stream title/description" -metadata:s:s:0 language=eng -metadata:s:s:0 title="Subtitle stream title/description" output.mkv
for f in *.mkv; do ffmpeg -y -i "$f" -codec copy -metadata comment="Matroska muxer also accepts free-form key/value metadata pairs" -metadata foo="bar" -metadata description="Matroska muxer description" -metadata:s:v:0 title="Video stream title/description" -metadata:s:a:0 title="Audio stream title/description" -metadata:s:s:0 language=eng -metadata:s:s:0 title="Subtitle stream title/description" ./working/"${f}"; done
```

Bash

Copy

Add Matroska Title metadata to the container while removing Title metadata from all of its streams (video, audio, subtitle)

```bash
ffmpeg -y -i input.mkv -f srt -i input.en.srt -map 0:v -map 0:a:1 -map 1:0 -movflags +faststart -metadata:s:v:0 language= -metadata:s:s:0 language=eng -metadata:s:v:0 Title= -metadata:s:a:0 Title= -metadata:s:s:0 Title= -metadata Title="Who Am I (1998)" -disposition 0 -disposition:s:1 default -c:v copy -c:a copy -c:s srt output.mkv
```

Bash

Copy

Change the Constant Rate Factor (CRF) which modifies output video quality and file size

```bash
ffmpeg -i inputfile -vcodec libx264 -crf 23 outputfile
```

Bash

Copy

Change/scale the video screen-size (for example to 1080p or half its pixel size)

```bash
ffmpeg -i inputfile -vf "scale=iw/2:ih/2" outputfile

# This method takes care of error: (libx264) "height not divisible by 2"
# https://stackoverflow.com/questions/20847674/ffmpeg-libx264-height-not-divisible-by-2
# https://superuser.com/questions/624563/how-to-resize-a-video-to-make-it-smaller-with-ffmpeg
ffmpeg -y -i "input.mp4" \
-map 0:v -map 0:a -dn -map_chapters -1 -filter:v scale="1920:trunc(ow/a/2)*2" \
-movflags faststart -profile:v high -pix_fmt yuv420p -metadata:s:a:0 language=eng \
-c:v libx264 -c:a copy "output.mp4"

##### Another one but different
ffmpeg -y -i "input.mp4" -map 0:v -map 0:a \
-dn -map_chapters -1 -metadata:s:v:0 handler_name= -metadata:s:a:0 handler_name= \
-vf pad=ceil(iw/2)*2:ceil(ih/2)*2 -movflags faststart -profile:v high -pix_fmt yuv420p \
-metadata:s:a:0 language=eng -c:v libx264 -c:a copy "output.mp4"
```

Bash

Copy

Brighten only dark scenes in a media file

```markdown
# https://ffmpeg.org/ffmpeg-filters.html#eq
# To brighten only the dark scenes in a media file using FFmpeg, you can use the eq filter with a higher brightness value for dark scenes and a lower value for bright scenes. This will make the darker areas appear brighter while maintaining the brightness of the brighter areas.

1. Identify the threshold:
Determine a value for the brightness increase. This value will determine how much brighter the dark scenes will become.
2. Use the eq filter:
FFmpeg\'s eq filter allows you to adjust brightness, contrast, and gamma. Use the following format:

    ffmpeg -i input.mp4 -vf "eq=brightness=brightness_value:contrast=contrast_value:saturation=saturation_value:gamma=gamma_value" output.mp4

* brightness_value: The value to increase brightness by (e.g., 0.1 for a 10% increase).
* contrast_value: The value to adjust the contrast by (e.g., 1.0 for no change, 1.2 for a 20% increase).
* saturation_value: The value to adjust saturation by (e.g., 1.0 for no change, 1.5 for a 50% increase).
* gamma_value: The value to adjust gamma by (e.g., 1.0 for no change, 1.5 for a 50% increase).

## Important Notes

> IMPORTANT TIP: The legacy FFmpeg video filter for color correction, including brightness, contrast, and saturation, was mp=eq2. It has since been deprecated and replaced by the eq filter.
> Attempting to use mp=eq2 in modern FFmpeg versions will result in an error.

The eq filter provides the same functionality with updated syntax. Here is an example of how the syntax changed:

### Legacy mp=eq2 syntax

ffmpeg -i input.mp4 -vf mp=eq2=contrast:brightness:saturation:gamma output.mp4

### Modern eq Filter Syntax

ffmpeg -i input.mp4 -vf eq=contrast=1.5:brightness=-0.1:saturation=1.2 output.mp4

The options can be specified by name, separated by colons (:), for clarity and to avoid the order-dependent issues of the older filter.

### Trial and Error

You might need to experiment with different brightness_value settings to achieve the desired result.

### Over-brightening

Be careful not to over-brighten the video, as it can cause white parts to appear washed out.

### Other Filters

You could also use other filters like gamma=1:1:1 for adjusting gamma.

## Example with Gamma Adjustment

    ffmpeg -i input.mp4 -vf "eq=brightness=0.1:contrast=1.2:saturation=1.5:gamma=1.2" output.mp4

This command will increase the brightness by 10% (brightness=0.1), increase contrast by 20% (contrast=1.2), increase the saturation by 50% (saturation=1.5), and increase gamma by 20% (gamma=1.2).
In summary, by using the eq filter and experimenting with brightness, contrast, saturation, and gamma values, you can effectively brighten only the dark scenes in your media file while preserving the brightness of the already bright scenes.
```

Markdown

Copy

ffprobe: Output filename, audio codec name, and number of channels

```bash
find . -mount -depth -maxdepth 1 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams a:0 -show_entries stream=codec_name,channels -of default=nw=1:nk=1 "{}")' \;
```

Bash

Copy

ffprobe: Output filename, and video codecs

```bash
find . -mount -depth -maxdepth 1 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "{}")' \;
```

Bash

Copy

ffprobe: Output filename and video bit depth

```bash
find . -mount -depth -maxdepth 1 -regextype posix-extended -regex '.*\.mkv$|.*\.mp4$' -type f -exec bash -c 'echo "{}" $(ffprobe -loglevel error -select_streams v:0 -show_entries stream=bits_per_raw_sample -of default=nw=1:nk=1 "{}")' \;
```

Bash

Copy

Incorporating Bash arithmetic into ffmpeg command

```bash
for f in *.mkv; do ffmpeg -y -i "${f}" -i "${f/.mkv/.m4a}" \
-c:v copy -b:a:0 128k -filter_complex "[a:0]aresample=async=1000[a:0]" -movflags faststart -c:a:0 aac -c:a:1 copy -c:s copy \
-map 0:v:0 -map 1:0 -map 0:a:0 $(i=1; while [ $i -lt 28 ]; do echo -n "-map 0:s:$((i++)) "; done) \
-metadata:s:a:0 language=eng -disposition 0 -disposition:a:0 default -disposition:s:0 default -metadata:s:s:0 title= \
-metadata:s:a comment= -shortest "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

Change the H.264 profile to Baseline

```bash
ffmpeg -i inputfile -profile:v baseline outputfile
```

Bash

Copy

Concatenate multiple media files

```bash
# https://trac.ffmpeg.org/wiki/Concatenate
for f in *.mkv; do echo "file '$f'" >> mylist.txt; done
ffmpeg -f concat -safe 0 -i "mylist.txt" "output.mkv"
```

Bash

Copy

Map only the languages you want in the audio and subtitle streams

```bash
# With this example we will only map the English audio and subtitle streams if they exist:
ffmpeg -y -i "input.mkv" -map 0:v:0 -map 0:a:m:language:eng -map "0:s:m:language:eng?" -c:v copy -codec:a copy -c:s srt "output.mkv"
for f in *.mkv; do ffmpeg -y -i "$f" -map 0:v:0 -map 0:a:m:language:eng -map "0:s:m:language:eng?" -c:v copy -c:a copy -c:s copy "path/$f"; done
```

Bash

Copy

Exclude only VobSub subtitles while copying all other subtitle streams using stream-based mapping with a negative filter

```bash
ffmpeg -i input.mkv -map 0 -map -0:s:m:handler_name:!dvd_subtitle -c copy output.mkv
for f in *.mkv; do ffmpeg -y -i "$f" -map 0 -map -0:s:m:handler_name:!dvd_subtitle -c copy "path/$f"; done
```

Bash

Copy

Insert arbitrary audio stream and alter the starttime offset with '-itsoffset' paramter

```bash
ffmpeg -y -i inputfile -itsoffset -500ms -f aac -i 'audio.aac' -map 0:v -map 1:0 -map 0:a:0 \
-disposition:a:0 default -disposition:a:1 0 -metadata:s:a:0 language=eng -metadata:s:a:1 \
language=eng -fflags +bitexact -flags:v +bitexact -flags:a +bitexact -ac 2 -c:v copy \
-c:a:0 aac -c:a:1 copy outputfile
```

Bash

Copy

Bitrate Guidelines

```bash
# Calculate the bitrate you need by dividing your target size (in bits)
# by the video length (in seconds). For example for a target size of
# 1 GB (one gigabyte, which is 8 gigabits) and 10,000 seconds of video
# (2:h 46 min 40 s), use a bitrate of 800 000 bit/s (800 kbit/s):
ffmpeg -i input.mp4 -b 800k output.mp4
```

Bash

Copy

Transcode avi files into standard mp4 containers

```bash
for f in **/*.avi; do ffmpeg -i "$f" -map 0:v:0 -map 0:a -dn -map_chapters -1 \
-movflags faststart -profile:v high -pix_fmt yuv420p -metadata:s:a:0 language=eng \
-metadata:s:v:0 title= -metadata:s:a:0 title= -c:v libx264 -c:a aac \
"../.working/${f/.avi/.mp4}"; done
```

Bash

Copy

Convert interlaced to progressive (1080i -> 1080p)

```bash
ffmpeg -i inputfile -vf yadif -c:v libx264 -preset slow -crf 19 -c:a aac -b:a 192k -c:s srt -max_muxing_queue_size 400 outputfile
ffmpeg -i "interlaced.mkv" -vf yadif=1 -movflags +faststart -y -preset fast -profile:v high -crf 20 -ac 2 -b:a 192k -strict experimental -c:v libx264 -c:a aac "progressive.mkv"
# yadif=0 is normally the preferred option when deinterlacing video as yadif=1 will double the frame-rate of the output video
ffmpeg -i "interlaced.mkv" -vf yadif=0 -y -preset fast -profile:v high -crf 20 -ac 2 -b:a 192k -strict experimental -c:v libx264 -c:a aac "progressive.mkv"
```

Bash

Copy

H.264 interlaced BT709 > H.264 progressive BT709

```bash
ffmpeg -i inputfile -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -vf "yadif=0, colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -b:v 6M -bufsize 6M -minrate 3M -maxrate 10M -profile:v high -pix_fmt yuv420p -preset slow -channel_layout "5.1" -strict experimental -max_muxing_queue_size 400 -c:v libx264 -c:a aac -c:s copy outputfile
```

Bash

Copy

Nvidia Hardware Accelerated Latency-Tolerant High-Quality H.264 Transcoding

```bash
# standard
ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -i inputfile -c:a copy -c:v h264_nvenc -preset p6 -tune hq -b:v 5M -bufsize 5M -maxrate 10M -qmin 0 -g 250 -bf 3 -b_ref_mode middle -temporal-aq 1 -rc-lookahead 20 -i_qfactor 0.75 -b_qfactor 1.1 outputfile
```

Bash

Copy

Nvidia HW accelerated H264 10-bit to 8-bit BT709 color

```bash
# for loop
for f in *.mkv; do ffmpeg -vsync 0 -hwaccel cuda -y -i "$f" -map 0 -profile:v high -pix_fmt yuv420p -preset slow -vf "colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -codec:v h264_nvenc -codec:a copy -codec:s copy "${f/.mkv/-modified.mkv}"; done
```

Bash

Copy

Nvidia HW Accelerated H.264 interlaced BT709 > H.264 progressive BT709

```bash
# standard
ffmpeg -vsync 0 -hwaccel cuda -y -i inputfile -map 0 -vf "yadif=0, colorspace=all=bt709:iall=bt601-6-625:fast=1" -profile:v high -pix_fmt yuv420p -preset slow -c:v h264_nvenc -c:a copy -c:s copy outputfile
# real-world example
ffmpeg -vsync 0 -hwaccel cuda -y -i inputfile.mkv -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -metadata title="Movie Title" -metadata:s:v:0 title= -metadata:s:a:0 title= -vf "yadif=0, colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -b:v 6M -bufsize 6M -minrate 3M -maxrate 10M -profile:v high -pix_fmt yuv420p -preset slow -channel_layout "5.1" -strict experimental -max_muxing_queue_size 400 -c:v h264_nvenc -c:a aac -c:s copy outputfile.mkv

```

Bash

Copy

For looped Nvidia HW-accelerated h264\_nvenc PAL bt601/bt470bg > NTSC transcoding

```bash
# verbose for loop:
for VAR in 01 02 03 04 05 06 07 08 09 10 11 12 13; do ffmpeg -vsync 0 -hwaccel cuda -y -i "VTS_$(echo $VAR)_1.VOB" -movflags faststart -map 0:v:0 -map 0:a:0 -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -x264-params "iall=bt601-6-625:fast=1" -color_range 1 -colorspace bt470bg -color_primaries bt470bg -color_trc gamma28 -metadata title="Title (year) S01E$(echo $VAR)" -metadata:s:a:0 title= -metadata:s:a:0 language=eng -disposition:s 0 -b:v 2500k -minrate 1000k -maxrate 2500k -b:a 128k -codec:v h264_nvenc -channel_layout:a:0 "stereo" -codec:a aac "Title - S01E$VAR.mp4"; done
# less-verbose for loop:
for VAR in {01..13}; do ffmpeg -vsync 0 -hwaccel cuda -y -i "VTS_$(echo $VAR)_1.VOB" -movflags faststart -map 0:v:0 -map 0:a:0 -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -x264-params "iall=bt601-6-625:fast=1" -color_range 1 -colorspace bt470bg -color_primaries bt470bg -color_trc gamma28 -metadata title="Title (year) S01E$(echo $VAR)" -metadata:s:a:0 title= -metadata:s:a:0 language=eng -disposition:s 0 -b:v 2500k -minrate 1000k -maxrate 2500k -b:a 128k -codec:v h264_nvenc -channel_layout:a:0 "stereo" -codec:a aac "Title - S01E$VAR.mp4"; done

```

Bash

Copy

H264 10-bit to 8-bit BT709 color

```bash
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -profile:v high -pix_fmt yuv420p -preset slow -vf "colorspace=all=bt709:iall=bt601-6-625:fast=1" -colorspace 1 -color_primaries 1 -color_trc 1 -metadata:s:a:0 title= -codec:v libx264 -codec:a copy -codec:s copy "${f/.mkv/-modified.mkv}"; done

```

Bash

Copy

Convert H.265 > H.264 and convert 6CH AC3 audio to AAC and copy only the first subtitle stream

```bash
find . -depth -name '*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s:0? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -channel_layout "5.1" -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;

```

Bash

Copy

Convert H.265 > H.264 and convert 6CH AC3 audio to AAC and copy all subtitle streams

```bash
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -ac 6 -ar 48000 -b:a 768k -channel_layout "5.1" -c:a aac -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

```

Bash

Copy

Convert H.265 > H.264 and retain original audio and all subtitles

```bash
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -movflags faststart -c:v libx264 -preset slow -c:a copy -c:s copy -crf 23 "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

```

Bash

Copy

Copy original video stream and convert 6CH AC3 audio to AAC and copy all subtitle streams

```bash
find . -depth -name '*x265*.mkv' -type f -exec bash -c 'ffmpeg -i "$0" -map 0:v:0 -map 0:a:0 -map 0:s? -c:v copy -ac 6 -ar 48000 -b:a 384k -channel_layout "5.1" -c:a aac -c:s copy "${0/x265/x264}"' {} \;; find . -name '*x265*' -type f -delete

```

Bash

Copy

Constant frame-rate with variable bitrate (VBR) nvidia hw-accel transcoding

```bash
# one-liner: Constant frame-rate with variable bitrate (VBR) nvidia hw-accel transcoding
for f in *.mkv; do ffmpeg -vsync 2 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0 -map_chapters -1 -dn -metadata title="${f/.mkv/}" -metadata:s:v:0 title= -metadata:s:a:0 title= -colorspace 1 -color_primaries 1 -color_trc 1 -r 24 -b:v 5M -minrate 3M -maxrate 8M -bufsize 10M -profile:v high -pix_fmt yuv420p -preset slow -strict experimental -max_muxing_queue_size 400 -c:v h264_nvenc -c:a copy -c:s copy "$f"; done

# multi-lined: Constant frame-rate with variable bitrate (VBR) nvidia hw-accel transcoding
for f in *.mkv; do ffmpeg -vsync 2 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs \
-map 0 -map_chapters -1 -dn -metadata title="${f/.mkv/}" -metadata:s:v:0 title= \
-metadata:s:a:0 title= -colorspace 1 -color_primaries 1 -color_trc 1 -r 24 \
-b:v 5M -minrate 3M -maxrate 8M -bufsize 10M -profile:v high -pix_fmt yuv420p -preset slow \
-strict experimental -max_muxing_queue_size 400 -c:v h264_nvenc -c:a copy -c:s copy \
"$f"; done

```

Bash

Copy

Generate thumbnails from video

```bash
# adjust the fps interval to change the number of thumbnails generated
ffmpeg -loglevel verbose -i 'input.mkv' -vf fps=1/1000 thumb-%03d.jpg
# add "-discard nokey" in order to generate thumbnails faster since it does not need to scan the file for every keyframe
ffmpeg -discard nokey -i 'input.mkv' -vf fps=1/300 thumb-%03d.png

```

Bash

Copy

vsync 1 CFR, cq = 30, avi > mp4

```bash
for f in *.avi; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -f srt -i "${f/avi/srt}" -map 0:v:0 -map 0:a -map 1:0 -dn -map_chapters -1 -movflags faststart -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 language=eng -metadata:s:s:0 title= -metadata:s:s:0 language=eng -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 30 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac -c:s mov_text "${f/.avi/.mp4}"; done

```

Bash

Copy

vsync 2 VFR, cq = 28, avi > mp4

```bash
for f in *.avi; do ffmpeg -loglevel verbose -vsync 2 -hwaccel cuda -y -i "$f" -f srt -i "${f/avi/srt}" -map 0:v:0 -map 0:a -map 1:0 -dn -map_chapters -1 -movflags faststart -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 language=eng -metadata:s:s:0 title= -metadata:s:s:0 language=eng -pix_fmt yuv420p -disposition:s:0 0 -r 24 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac -c:s mov_text "${f/.avi/.mp4}"; done

```

Bash

Copy

vsync 1 CFR, cq = 30, mp4 > mp4

```bash
for f in *.mp4; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -f srt -i "${f/avi/srt}" -map 0:v:0 -map 0:a -map 1:0 -dn -map_chapters -1 -movflags faststart -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -metadata:s:a:0 language=eng -metadata:s:s:0 title= -metadata:s:s:0 language=eng -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 30 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "stereo" -c:a aac -c:s mov_text "${f/.avi/.mp4}"; done

```

Bash

Copy

vsync 1 CFR of 24fps (-r 24), cq = 28

```bash
for f in *.mkv; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -r 24 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -c:a copy -c:s copy "${f/.mkv/-modified.mkv}"; done

```

Bash

Copy

vsync 1 CFR, cq = 28, variable bit rate, keep existing frame rate

```bash
for f in *.mkv; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "5.1" -c:a aac -c:s copy "${f/.mkv/-modified.mkv}"; done

```

Bash

Copy

vsync 1 CFR, cq = 23, variable bit rate, keep existing frame rate

```bash
for f in *.mkv; do ffmpeg -loglevel info -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -dn -map_chapters -1 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 23 -level:v 4.1 -rc vbr -cbr:v false -channel_layout "5.1" -c:a aac -c:s copy "${f/.mkv/-modified.mkv}"; done

```

Bash

Copy

stream copy/remux, not changing much except for subtitle deposition and other minor changes

```bash
for f in *.mkv; do ffmpeg -y -i "$f" -default_mode infer_no_subs -map 0 -dn -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -disposition:v:0 default -disposition:a:0 default -disposition:s 0 -c:v copy -c:a copy -c:s copy "$f"; done

```

Bash

Copy

avi > mp4 transcoding, constant frame rate at 24fps, variable bit rate, cq 28

```bash
for f in */**.avi; do ffmpeg -loglevel verbose -vsync 1 -hwaccel cuda -y -i "$f" -default_mode infer_no_subs -map 0:v:0 -map 0:a -map "0:s?" -movflags faststart -dn -map_chapters -1 -r 24 -metadata title= -metadata:s:v:0 title= -metadata:s:a:0 title= -metadata:s:a:0 language=eng -metadata creation_time="$(date --iso-8601=seconds)" -metadata:s:v creation_time="$(date --iso-8601=seconds)" -metadata:s:a creation_time="$(date --iso-8601=seconds)" -pix_fmt yuv420p -disposition:s:0 0 -disposition:v:0 default -disposition:a:0 default -c:v h264_nvenc -profile:v high -preset p5 -tune hq -b:v 0 -cq 28 -level:v 4.1 -rc vbr -cbr:v false -channel_layout:a:0 "stereo" -c:a aac -c:s srt "${f/avi/mp4}"; done

```

Bash

Copy

INTERNAL MEDIA TERMINOLOGIES

```text
CFR = Constant Frame Rate
VFR = Variable Frame Rate
CBR = Constant Bit Rate
VBR = Variable Bit Rate

```

Plain text

Copy
