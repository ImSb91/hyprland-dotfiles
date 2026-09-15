#!/bin/bash

# Toggle default-sink mute
pamixer -t

# Update mute LED (no sudo password needed)
if [ "$(pamixer --get-mute)" = "true" ]; then
  sudo /usr/local/bin/mute-led 1
else
  sudo /usr/local/bin/mute-led 0
fi