#!/usr/bin/env bash
# Generate previews for any cliphist images that don't have one yet.
THUMB="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-thumbs"
mkdir -p "$THUMB"
cliphist list 2>/dev/null | while IFS=$'\t' read -r id rest; do
  [ -z "$id" ] && continue
  [[ "$rest" == *binary* ]] || continue
  ext=$(sed -nE 's/.* (jpe?g|png|webp|gif|bmp) .*/\1/p' <<<"$rest"); [ -n "$ext" ] || continue
  [ -f "$THUMB/$id.prev.png" ] && continue
  printf '%s\n' "$rest" | cliphist decode > "$THUMB/$id.$ext" 2>/dev/null
  magick "$THUMB/$id.$ext" -auto-orient -strip -resize '256x256>' "$THUMB/$id.prev.png" 2>/dev/null
done
sleep 110
