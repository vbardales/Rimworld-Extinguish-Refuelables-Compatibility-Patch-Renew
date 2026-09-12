#!/bin/bash
# Render the Preview from Art/Preview.png with the JSON palette and HTML/CSS in Art/.
# Chrome/Playwright waits for fonts; Sharp writes PNG and QA artifacts under 900 KB.
# ModIcon is rebuilt separately from its unchanged original using ffmpeg.
set -e
cd "$(dirname "$0")/.."
node Art/render-preview.cjs
ffmpeg -v error -y -i Art/ModIcon-source.png -vf "scale=128:128:flags=lanczos" \
  -compression_level 100 -pred mixed Mod/About/ModIcon.png
ls -l Mod/About
