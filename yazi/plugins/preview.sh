#!/usr/bin/env bash

file="$1"

# Exit if file doesn't exist
[ ! -e "$file" ] && exit 1

# If it's a directory, list contents
[ -d "$file" ] && ls --color=always "$file" && exit 0

# If it's empty, still preview something
if [ ! -s "$file" ]; then
  echo "[Empty file]"
  exit 0
fi

# Normal preview with bat, fallback to cat
bat --style=plain --color=always "$file" 2>/dev/null || cat "$file"
