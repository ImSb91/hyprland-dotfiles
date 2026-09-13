#!/bin/bash

THUMB_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-thumbs"
mkdir -p "$THUMB_DIR"

# Renders a readable one-liner out of a possible binary/unicode preview
sanitize() {
  printf '%s\n' "$1" | tr -cd '[:print:]'
}

# Direct-path icon for a cliphist image: decode once, make a 256px preview.
# rofi script-mode renders absolute paths in `\0icon` (verified).
prev_of() { # $1=id, $2=ext, $3=rawline
  local src="$THUMB_DIR/$1.$2"
  if [ ! -f "$src" ]; then
    printf '%s\n' "$3" | cliphist decode 2>/dev/null > "$src"
  fi
  local prev="$THUMB_DIR/$1.prev.png"
  if [ ! -f "$prev" ] && [ -f "$src" ]; then
    magick "$src" -auto-orient -strip -resize '256x256>' "$prev" 2>/dev/null
  fi
  [ -f "$prev" ] && printf '%s' "$prev" || printf ''
}

if [ -z "$1" ]; then
  while IFS=$'\t' read -r id rest; do
    [ -z "$id" ] && continue
    raw="$id"$'\t'"$rest"

    if [[ "$rest" =~ \[\[[[:space:]]binary[[:space:]]data.*[[:space:]](jpe?g|png|webp|gif|bmp)[[:space:]] ]]; then
      ext="${BASH_REMATCH[1]}"
      icon="$(prev_of "$id" "$ext" "$raw")"
      display="${rest//\[\[ binary data /}"
      display="${display%]]}"
      printf '%s\0display\x1f🖼 %s' "$raw" "$display"
      [ -n "$icon" ] && printf '\0icon\x1f%s' "$icon"
      printf '\n'
    else
      printf '%s\0display\x1f%s\n' "$raw" "$(sanitize "$rest")"
    fi
  done < <(cliphist list)
  exit 0
fi

echo "$1" | cliphist decode | wl-copy