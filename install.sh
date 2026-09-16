#!/usr/bin/env bash
#
# hyprland-dotfiles installer
# Sets up THIS config on a fresh Arch Linux box (configs only -- no documents,
# games or secrets). Run as your normal (non-root) user; sudo will prompt.
#
#   git clone https://github.com/ImSb91/hyprland-dotfiles
#   cd hyprland-dotfiles && ./install.sh
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$HOME/.config"
STAMP="$(date +%Y%m%d%H%M%S)"
BACKUP="$HOME/.dotfiles-backup-$STAMP"

msg() { printf '\n\033[1;34m== %s ==\033[0m\n' "$*"; }
ok()  { printf '\033[1;32m   %s\033[0m\n' "$*"; }
warn(){ printf '\033[1;33m!! %s\033[0m\n' "$*"; }

if [ "$(id -u)" = 0 ]; then
  warn "Run as your normal user, NOT root."; exit 1
fi

mkdir -p "$CONF" "$BACKUP"

# ---------------------------------------------------------------------------
msg "1/5  Installing packages (from the official repos)"
# ---------------------------------------------------------------------------
PKGS=(
  hyprland hyprpaper hyprlock hypridle          # compositor + extras
  waybar rofi swaync                             # bar / menus / notifications
  kitty nvim zsh                                 # terminal / editor / shell
  zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
  fzf zoxide atuin                               # shell productivity
  pamixer playerctl brightnessctl grim wl-clipboard imagemagick
  bc jq curl
  ttf-jetbrains-mono-nerd ttf-iosevka           # fonts used by kitty/itu-line
)
if command -v pacman >/dev/null; then
  sudo pacman -S --needed --noconfirm "${PKGS[@]}"
else
  warn "pacman not found -- skipping package install."
fi

# Optional / AUR helpers. Installed automatically when yay is present.
YAYPKGS=(hyprshot rofimoji cliphist ryzenadj swaykbdd)
if command -v yay >/dev/null; then
  msg "Installing AUR helpers via yay"
  yay -S --needed --noconfirm "${YAYPKGS[@]}" || warn "Some AUR packages failed -- install manually."
else
  warn "yay not found. After setup consider:\n   sudo pacman -S --needed base-devel git\n   git clone https://aur.archlinux.org/yay && cd yay && makepkg -si\n   yay -S hyprshot rofimoji cliphist ryzenadj swaykbdd"
fi

# ---------------------------------------------------------------------------
msg "2/5  Deploying configuration files"
# ---------------------------------------------------------------------------
backup_existing() { # $1 = target path
  if [ -e "$1" ]; then
    cp -a "$1" "$BACKUP/$(basename "$1").$STAMP" 2>/dev/null || true
  fi
}

for dir in hypr rofi swaync waybar yazi nvim kitty; do
  if [ -d "$REPO/$dir" ]; then
    backup_existing "$CONF/$dir"
    cp -a "$REPO/$dir" "$CONF/"
    ok "$dir -> $CONF/$dir"
  fi
done

if [ -f "$REPO/home/.zshrc" ]; then
  backup_existing "$HOME/.zshrc"
  cp -a "$REPO/home/.zshrc" "$HOME/.zshrc"
  ok ".zshrc -> $HOME/.zshrc"
fi

mkdir -p "$HOME/.local/bin"
if [ -x /usr/bin/atuin ] && [ ! -e "$HOME/.local/bin/atuin" ]; then
  ln -s /usr/bin/atuin "$HOME/.local/bin/atuin" && ok "atuin -> ~/.local/bin/atuin"
fi

# weather API key (optional)
if [ ! -f "$HOME/.owm-key" ]; then
  warn "Weather module wants an OpenWeather API key at ~/.owm-key"
fi

# ---------------------------------------------------------------------------
msg "3/5  Creating root helpers (mute/mic LEDs + fan) and sudo rules"
# ---------------------------------------------------------------------------
sudo tee /usr/local/bin/mic-led >/dev/null <<'EOF'
#!/bin/bash
echo "$1" > /sys/class/leds/platform::micmute/brightness
EOF
sudo tee /usr/local/bin/mute-led >/dev/null <<'EOF'
#!/bin/bash
echo "$1" > /sys/class/leds/platform::mute/brightness
EOF
sudo chmod 755 /usr/local/bin/mic-led /usr/local/bin/mute-led
ok "/usr/local/bin/mic-led, /usr/local/bin/mute-led"

sudo tee "/etc/sudoers.d/dotfiles-$USER" >/dev/null <<EOF
$(id -un) ALL=(ALL) NOPASSWD: /usr/local/bin/mic-led, /usr/local/bin/mute-led, /usr/bin/tee /proc/acpi/ibm/fan, /home/$USER/.config/hypr/scripts/watt10.sh, /home/$USER/.config/hypr/scripts/watt15.sh, /home/$USER/.config/hypr/scripts/watt30.sh, /usr/bin/ryzenadj
EOF
sudo chmod 440 "/etc/sudoers.d/dotfiles-$USER"
ok "sudoers rules installed"

# ---------------------------------------------------------------------------
msg "4/5  Installing nvim plugins (first run)"
# ---------------------------------------------------------------------------
if command -v nvim >/dev/null; then
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "nvim plugin sync had issues -- run again: nvim --headless \"+Lazy sync\""
  ok "nvim plugins installed"
fi

# ---------------------------------------------------------------------------
msg "5/5  Done"
# ---------------------------------------------------------------------------
cat <<NOTES
Configs installed. Old versions (if any) were backed up to: $BACKUP

Next steps:
  1. Log in to a new session (or run: Hyprland) -- or 'hyprctl reload' if already inside.
  2. On a ThinkPad: press Fn+Esc so the Esc LED is ON (F1-F12 = real F-keys;
     FN+F1..F12 = media). Shortcuts work in the EN layout.
  3. Keyboard: Ctrl+Alt+Shift+1/2/3 = power profiles, 0/7/9 = fan speed.
  4. Notifications use swaync (2s auto-dismiss, Super+N opens the center).
  5. zsh gets its plugins via the installed packages; open a new terminal.
  6. nvim: full-stack LSP (vtsls, html/css/json, pyright+ruff, tailwindcss).

Recommended extras (optional): 
  yay -S catppuccin-gtk-theme catppuccin-cursors-git
NOTES