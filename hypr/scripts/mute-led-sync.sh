#!/bin/bash

# On boot the firmware lights the mic-mute LED even though the mic is live.
# Wait until PipeWire answers, then sync BOTH mute LEDs to the real state.

for i in {1..50}; do
  pamixer --default-source --get-mute >/dev/null 2>&1 && break
  sleep 0.2
done

if [ "$(pamixer --default-source --get-mute 2>/dev/null)" = "true" ]; then
  sudo /usr/local/bin/mic-led 1
else
  sudo /usr/local/bin/mic-led 0
fi

if [ "$(pamixer --get-mute 2>/dev/null)" = "true" ]; then
  sudo /usr/local/bin/mute-led 1
else
  sudo /usr/local/bin/mute-led 0
fi