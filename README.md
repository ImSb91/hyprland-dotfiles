# Hyprland Dotfiles

## Showcase

![Showcase 1](Showcase1.png)

![Showcase 2](Showcase2.png)

![Showcase 3](Showcase3.png)

## Requirements

- **Arch Linux** (rolling) with `sudo`
- Optional: `yay` for the small set of AUR helpers (`hyprshot`, `rofimoji`, `cliphist`, `ryzenadj`, `swaykbdd`)

## Install

```bash
git clone https://github.com/ImSb91/hyprland-dotfiles
cd hyprland-dotfiles
./install.sh
```

## Keybindings

`Super` = main modifier.

| Key | Action |
| --- | --- |
| `Super+Return` | Terminal (kitty) |
| `Super+Q` | Close window |
| `Super+M` | Exit Hyprland |
| `Super+E` | File manager (kitty + yazi) |
| `Super+D` / `Alt+Space` | App menu / run menu |
| `Super+X` | Clipboard history |
| `Super+N` | Notification center |
| `Super+C` / `Super+Z` | Calculator / Rofimoji |
| `Super+1..0` | Switch workspace |
| `Super+Shift+1..0` | Move window to workspace |
| `Super+H/J/K/L` | Focus in direction |
| `Super+Shift+arrows` | Resize window |
| `Super+T` / `Super+S` | Tiled / floating |
| `Print`, `Ctrl+Print`, `Super+Print` | Screenshot: region / output / window |
| `Ctrl+Shift+R/P` | Start / stop screen record |

## Layout

```
home/.zshrc  hypr/     rofi/    swaync/    waybar/
yazi/        nvim/     kitty/   install.sh
```