#!/usr/bin/env bash
# Background refresher for the rofi clipboard: warm thumbnails + re-render list.
THUMB="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-thumbs"
mkdir -p "$THUMB"

# 1. warm missing previews
cliphist list 2>/dev/null | while IFS=$'\t' read -r id rest; do
  [ -z "$id" ] && continue
  [[ "$rest" == *binary* ]] || continue
  ext=$(sed -nE 's/.* (jpe?g|png|webp|gif|bmp) .*/\1/p' <<<"$rest"); [ -n "$ext" ] || continue
  [ -f "$THUMB/$id.prev.png" ] && continue
  printf '%s\n' "$rest" | cliphist decode > "$THUMB/$id.$ext" 2>/dev/null
  magick "$THUMB/$id.$ext" -auto-orient -strip -resize '256x256>' "$THUMB/$id.prev.png" 2>/dev/null
done

# 2. rebuild the rofi list cache
CLIP_CACHE_MODE=warm "$HOME/.config/hypr/scripts/cliphist-rofi-img"

sleep 110
