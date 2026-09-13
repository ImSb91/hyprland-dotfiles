#!/bin/bash

# Ask the user for a file or folder name
read -p "Enter file/folder name: " name

# Cancel if empty
[ -z "$name" ] && exit 0

# If it ends with '/', create a directory
if [[ "$name" == */ ]]; then
  mkdir -p "$name"
  exit 0
fi

# Else, create a file with sensible defaults
touch "$name"

# Add a shebang or empty line if needed
case "$name" in
*.sh)
  echo '#!/bin/bash' >"$name"
  chmod +x "$name"
  ;;
*.py)
  echo '#!/usr/bin/env python3' >"$name"
  chmod +x "$name"
  ;;
*)
  echo '' >"$name"
  ;;
esac
