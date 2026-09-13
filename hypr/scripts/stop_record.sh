#!/usr/bin/env bash
# Kill the ffmpeg process
pkill -x wf-recorder

notify-send -i ~/.config/hypr/scripts/icons/camera.png "ffmpeg" "Recording stopped"
