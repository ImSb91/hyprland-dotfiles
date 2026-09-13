#!/bin/bash

layouts=$(hyprctl devices | grep "active keymap" | awk -F': ' '{print $2}' | sort -u)

layout=$(echo "$layouts" | grep -v "English (US)" | head -n1)

if [ -z "$layout" ]; then
  layout="English (US)"
fi

case "$layout" in
"Arabic") label="ara" ;;
"English (US)") label="eng" ;;
*) label="$layout" ;;
esac

# FIX: Removed the spaces around the = sign
icon='󰌌'
color="#facc15"

echo "{\"text\": \"$label\", \"tooltip\": \"Layout: $layout\"}"
