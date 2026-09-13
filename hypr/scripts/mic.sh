#!/bin/bash

# Toggle mic mute
pamixer --default-source -t

# Get mute status
muted=$(pamixer --default-source --get-mute)

# Update LED (no sudo password needed)
if [ "$muted" = "true" ]; then
  sudo /usr/local/bin/mic-led 1
else
  sudo /usr/local/bin/mic-led 0
fi
