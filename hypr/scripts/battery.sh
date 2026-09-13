#!/usr/bin/env bash

BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Custom icons path
ICONS_DIR="$HOME/.config/hypr/scripts/icons"

# Notification thresholds
LAST_NOTIFY_FILE="/tmp/battery_last_notify"
THRESHOLDS="20 30 80"

# Pick default (discharging) icon based on percentage
if [ "$BATTERY" -ge 100 ]; then
  ICON="󰁹"
elif [ "$BATTERY" -ge 90 ]; then
  ICON="󰂂"
elif [ "$BATTERY" -ge 80 ]; then
  ICON="󰂁"
elif [ "$BATTERY" -ge 70 ]; then
  ICON="󰂀"
elif [ "$BATTERY" -ge 60 ]; then
  ICON="󰁿"
elif [ "$BATTERY" -ge 50 ]; then
  ICON="󰁾"
elif [ "$BATTERY" -ge 40 ]; then
  ICON="󰁽"
elif [ "$BATTERY" -ge 30 ]; then
  ICON="󰁼"
elif [ "$BATTERY" -ge 20 ]; then
  ICON="󰁻"
elif [ "$BATTERY" -ge 10 ]; then
  ICON="󰁺"
else
  ICON="󱃍"
fi
# Set color based on level
if [ "$BATTERY" -le 20 ]; then
  ICON_COLOR="#f38ba8" # red
elif [ "$BATTERY" -le 30 ]; then
  ICON_COLOR="#fab387" # orange
elif [ "$BATTERY" -le 40 ]; then
  ICON_COLOR="#f9e2af" # yellow
else
  ICON_COLOR="#a6e3a1" # green
fi

# Override icon if charging
if [ "$STATUS" = "Charging" ]; then
  ICON_COLOR="#89b4fa"

  if [ "$BATTERY" -ge 100 ]; then
    ICON="󰂅"
  elif [ "$BATTERY" -ge 90 ]; then
    ICON="󰂋"
  elif [ "$BATTERY" -ge 80 ]; then
    ICON="󰂊"
  elif [ "$BATTERY" -ge 70 ]; then
    ICON="󰢞"
  elif [ "$BATTERY" -ge 60 ]; then
    ICON="󰂉"
  elif [ "$BATTERY" -ge 50 ]; then
    ICON="󰢝"
  elif [ "$BATTERY" -ge 40 ]; then
    ICON="󰂈"
  elif [ "$BATTERY" -ge 30 ]; then
    ICON="󰂇"
  elif [ "$BATTERY" -ge 20 ]; then
    ICON="󰂆"
  else
    ICON="󰢜"
  fi
fi

# --- NOTIFICATION LOGIC WITH CUSTOM ICONS ---
send_notification() {
  local current_time
  current_time=$(date +%s)
  local last_notify_time
  last_notify_time=$(cat "$LAST_NOTIFY_FILE" 2>/dev/null || echo 0)

  if { [[ " $THRESHOLDS " == *" $BATTERY "* ]] || [[ "$1" == "charging" ]]; } &&
    ((current_time - last_notify_time > 300)); then
    case $BATTERY in
    20)
      notify-send -u critical -i "$ICONS_DIR/battery_low.png" \
        "Warning! (20%)" "Battery low"
      ;;
    30)
      notify-send -u normal -i "$ICONS_DIR/battery_warning.png" \
        "Warning (30%)" "Battery Warning"
      ;;
    79)
      notify-send -u low -i "$ICONS_DIR/battery_full.png" \
        "Battery Charged (80%)" "Battery full"
      ;;
    esac

    if [[ "$1" == "charging" ]]; then
      notify-send -u normal -i "$ICONS_DIR/battery_charging.png" \
        "Charger Connected" "Battery charging"
    fi

    echo "$current_time" >"$LAST_NOTIFY_FILE"
  fi
}

# Notification checks
if [[ " $THRESHOLDS " == *" $BATTERY "* ]]; then
  send_notification
elif [[ "$STATUS" = "Charging" ]] && [[ ! -f "/tmp/battery_charging_notified" ]]; then
  send_notification "charging"
  touch "/tmp/battery_charging_notified"
elif [[ "$STATUS" != "Charging" ]] && [[ -f "/tmp/battery_charging_notified" ]]; then
  rm "/tmp/battery_charging_notified"
fi

# Final JSON output for Waybar
echo "{\"text\": \"<span color='${ICON_COLOR}'>${ICON} </span>${BATTERY}%\", \"tooltip\": true}"
