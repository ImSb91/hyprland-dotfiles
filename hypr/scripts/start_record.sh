#!/usr/bin/env bash

# 1. Ensure the output directory exists
TARGET_DIR="$HOME/Videos/screenrecodrings"
mkdir -p "$TARGET_DIR"

# 2. Define the output file path using that directory
output_file="$TARGET_DIR/$(date '+%Y-%m-%d_%H-%M-%S').mp4"

# 3. Check if wf-recorder (NOT ffmpeg) is already running
if pgrep -x "wf-recorder" >/dev/null; then
  echo "Recording is already in progress."
  notify-send -i ~/.config/hypr/scripts/icons/camera.png "Screen Recorder" "Recording is already in progress!"
  exit 1
fi

# 4. Start recording using wf-recorder and the variable we defined
wf-recorder -f "$output_file" -r 30 --audio=bluez_output.62_A2_CF_10_65_E2.1.monitor --codec libx264 --crf 28 &

# 5. Notify the user
notify-send -i ~/.config/hypr/scripts/icons/camera.png "Screen Recorder" "Recording started"
