#!/usr/bin/env bash
# SETTINGS
APIKEY=$(cat "$HOME/.owm-key")
CITY_NAME='Mascara'
COUNTRY_CODE='DZ'
LANG="en"
UNITS="metric"
BEAUFORTICON="yes" # Set default value if not defined

# Catppuccin Mocha Colors
COLOR_CLOUD="#6c7086"
COLOR_THUNDER="#d3b987"
COLOR_LIGHT_RAIN="#73cef4"
COLOR_HEAVY_RAIN="#74c7ec"
COLOR_SNOW="#FFFFFF"
COLOR_FOG="#7f849c"
COLOR_TORNADO="#d3b987"
COLOR_SUN="#f9e2af"
COLOR_MOON="#FFFFFF"
COLOR_ERR="#f38ba8"
COLOR_WIND="#73cef4"
COLOR_COLD="#73cef4"
COLOR_HOT="#f38ba8"
COLOR_NORMAL_TEMP="#fab387"
COLOR_WHITE="#cdd6f4"

# Temperature Thresholds
HOT_TEMP=34
MID_TEMP=27
COLD_TEMP=10

# Cache last successful result so a network cut never shows a blank "?"
CACHE_FILE="$HOME/.cache/waybar-weather"
STALE_AFTER=600      # seconds before we refresh a successful fetch
CACHE_MAX_AGE=86400  # never show data older than a day (boot w/ old cache)

CACHE_FRESH=0
if [ -f "$CACHE_FILE" ]; then
  CACHE_TS=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
  NOW_TS=$(date +%s)
  if [ $((NOW_TS - CACHE_TS)) -lt "$STALE_AFTER" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
  # stale but recent enough to show while offline instead of "?"
  if [ $((NOW_TS - CACHE_TS)) -lt "$CACHE_MAX_AGE" ]; then
    CACHE_FRESH=1
  fi
fi

# API Call (tight timeouts so the module never hangs on a dead connection)
URL="https://api.openweathermap.org/data/2.5/weather?appid=$APIKEY&units=$UNITS&lang=$LANG&q=$(echo $CITY_NAME | sed 's/ /%20/g'),${COUNTRY_CODE}"
RESPONSE=$(curl -s --connect-timeout 2 --max-time 4 "$URL")

if [ -z "$RESPONSE" ] || [ "$(echo "$RESPONSE" | jq -r .cod)" != "200" ]; then
  if [ "$CACHE_FRESH" = "1" ]; then
    # internet dropped: keep showing last known weather until it's back
    cat "$CACHE_FILE"
  else
    echo "{ \"text\":\" \", \"tooltip\": \"Weather data unavailable\", \"class\": \"weather\", \"color\": \"${COLOR_ERR}\" }"
  fi
  exit 0
fi

# Extract Data
WID=$(echo "$RESPONSE" | jq -r .weather[0].id)
TEMP=$(echo "$RESPONSE" | jq -r .main.temp | awk '{print int($1)}')
TEMP_INT=$(echo "$TEMP" | awk '{printf "%.0f", $1}')
SUNRISE=$(echo "$RESPONSE" | jq -r .sys.sunrise)
SUNSET=$(echo "$RESPONSE" | jq -r .sys.sunset)
DATE=$(date +%s)

# Determine Weather Icon and Color
function setIcons {
  ICON=""              # Default to question mark if no match
  ICON_COLOR=$COLOR_ERR # Default error color

  if [ "$WID" -le 232 ]; then
    ICON_COLOR=$COLOR_THUNDER
    ICON=""
  elif [ "$WID" -le 321 ]; then
    ICON_COLOR=$COLOR_LIGHT_RAIN
    ICON=""
  elif [ "$WID" -le 531 ]; then
    ICON_COLOR=$COLOR_HEAVY_RAIN
    ICON=""
  elif [ "$WID" -le 622 ]; then
    ICON_COLOR=$COLOR_SNOW
    ICON=""
  elif [ "$WID" -le 771 ]; then
    ICON_COLOR=$COLOR_FOG
    ICON=""
  elif [ "$WID" -eq 781 ]; then
    ICON_COLOR=$COLOR_TORNADO
    ICON=""
  elif [ "$WID" -eq 800 ]; then
    if [ "$DATE" -ge "$SUNRISE" ] && [ "$DATE" -le "$SUNSET" ]; then
      ICON_COLOR=$COLOR_SUN
      ICON=""
    else
      ICON_COLOR=$COLOR_MOON
      ICON=""
    fi
  elif [ "$WID" -eq 801 ]; then
    if [ "$DATE" -ge "$SUNRISE" ] && [ "$DATE" -le "$SUNSET" ]; then
      ICON_COLOR=$COLOR_SUN
      ICON=""
    else
      ICON_COLOR=$COLOR_MOON
      ICON=""
    fi
  elif [ "$WID" -le 804 ]; then
    ICON_COLOR=$COLOR_CLOUD
    ICON=""
  fi

  # Wind Speed Calculation
  WINDFORCE=$(echo "$RESPONSE" | jq -r .wind.speed)
  WINDFORCE_KMH=$(awk "BEGIN {printf \"%.1f\", $WINDFORCE * 3.6}") # Convert m/s to km/h

  # Default Wind Icon & Color
  WINDICON=" "
  WINDICON_COLOR="#74c7ec"

  if [ "$BEAUFORTICON" == "yes" ]; then
    if (($(echo "$WINDFORCE_KMH <= 1" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#74c7ec"
    elif (($(echo "$WINDFORCE_KMH > 1 && $WINDFORCE_KMH <= 5" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#89b4fa"
    elif (($(echo "$WINDFORCE_KMH > 5 && $WINDFORCE_KMH <= 11" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#89b4fa"
    elif (($(echo "$WINDFORCE_KMH > 11 && $WINDFORCE_KMH <= 19" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#f9e2af"
    elif (($(echo "$WINDFORCE_KMH > 19 && $WINDFORCE_KMH <= 28" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#f38ba8"
    elif (($(echo "$WINDFORCE_KMH > 28 && $WINDFORCE_KMH <= 38" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#f7768e"
    elif (($(echo "$WINDFORCE_KMH > 38 && $WINDFORCE_KMH <= 49" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#e64553"
    elif (($(echo "$WINDFORCE_KMH > 49 && $WINDFORCE_KMH <= 61" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#d20f39"
    elif (($(echo "$WINDFORCE_KMH > 61" | bc -l))); then
      WINDICON=" "
      WINDICON_COLOR="#c34043"
    fi
  fi
}

# Determine Temperature Color
function formatTemperature {
  if [ "$TEMP_INT" -le "$COLD_TEMP" ]; then
    TEMP_COLOR=$COLOR_COLD
    TEMP_ICON="" # Cold: Snowflake
  elif [ "$TEMP_INT" -lt "$MID_TEMP" ]; then
    TEMP_COLOR=$COLOR_WHITE
    TEMP_ICON="" # Cool: Thermometer low
  elif [ "$TEMP_INT" -lt "$HOT_TEMP" ]; then
    TEMP_COLOR=$COLOR_NORMAL_TEMP
    TEMP_ICON="" # Warm: Thermometer medium
  else
    TEMP_COLOR=$COLOR_HOT
    TEMP_ICON="" # Hot: Thermometer full
  fi
}

setIcons
formatTemperature

# Output JSON for Waybar with Pango Markup
OUTPUT="{ \"text\": \"<span color='${ICON_COLOR}'>${ICON}</span> <span color='${TEMP_COLOR}'>${TEMP_ICON}</span> ${TEMP}°C\", \"tooltip\": \"Weather: ${ICON} ${TEMP}°C | Wind: ${WINDFORCE_KMH} km/h\", \"class\": \"weather\", \"color\": \"${COLOR_WHITE}\" }"

printf '%s\n' "$OUTPUT" > "$CACHE_FILE"
printf '%s\n' "$OUTPUT"