#!/bin/bash
# Builds the two Workshop images from the generated sources in Art/.
#
#   Art/Preview-source.png   ->  Mod/About/Preview.png    896 x 504, under 900 KB
#   Art/ModIcon-source.png   ->  Mod/About/ModIcon.png    128 x 128, 20-30 KB
#
# The banner's title and summary are engraved by rendering _tools/preview.html
# in headless Chrome at exactly 896 x 504: the text is therefore composed at its
# final size and its glyphs are never resampled. Chrome is also the only
# rasteriser installed on this machine.
#
# Chrome writes a fat PNG - the first capture came out at 1.2 MB, over Steam's
# hard limit - so ffmpeg re-encodes it. Both files come from the full-resolution
# sources, never from an already-reduced copy.
set -e
cd "$(dirname "$0")/.."
CH="/c/Program Files/Google/Chrome/Application/chrome.exe"
B="$(pwd -W 2>/dev/null || pwd)"
mkdir -p Mod/About

"$CH" --headless --no-sandbox --disable-gpu --hide-scrollbars \
  --window-size=896,504 --force-device-scale-factor=1 \
  --screenshot="$B/_tools/preview-raw.png" "file:///$B/_tools/preview.html" >/dev/null 2>&1

ffmpeg -v error -y -i _tools/preview-raw.png \
  -compression_level 100 -pred mixed Mod/About/Preview.png
rm -f _tools/preview-raw.png

ffmpeg -v error -y -i Art/ModIcon-source.png -vf "scale=128:128:flags=lanczos" \
  -compression_level 100 -pred mixed Mod/About/ModIcon.png

ls -l Mod/About
