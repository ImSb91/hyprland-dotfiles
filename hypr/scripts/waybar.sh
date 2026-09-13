#!/bin/bash
# Terminate already running waybar instances
pkill waybar

# Wait until the processes have been cleanly shut down
while pkill -x waybar >/dev/null; do sleep 0.1; done

# Launch waybar
waybar &
