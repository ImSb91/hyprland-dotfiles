#  ╔═╗╔═╗╦ ╦╦═╗╔═╗  ╔═╗╔═╗╔╗╔╔═╗╦╔═╗	- z0mbi3
#  ╔═╝╚═╗╠═╣╠╦╝║    ║  ║ ║║║║╠╣ ║║ ╦	- https://github.com/gh0stzk/dotfiles
#  ╚═╝╚═╝╩ ╩╩╚═╚═╝  ╚═╝╚═╝╝╚╝╚  ╩╚═╝	- My zsh conf

#  ┬  ┬┌─┐┬─┐┌─┐
#  └┐┌┘├─┤├┬┘└─┐
#   └┘ ┴ ┴┴└─└─┘
export VISUAL="nvim"
export EDITOR='nvim'
export TERMINAL='kitty'
export BROWSER='firefox'
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export HYPRSHOT_DIR="$HOME/Pictures/Screenshots"

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

#  ┬  ┌─┐┌─┐┌┬┐  ┌─┐┌┐┌┌─┐┬┌┐┌┌─┐
#  │  │ │├─┤ ││  ├┤ ││││ ┬││││├┤ 
#  ┴─┘└─┘┴ ┴─┴┘  └─┘┘└┘└─┘┴┘└┘└─┘
autoload -Uz compinit

for dump in ~/.config/zsh/zcompdump(N.mh+24); do
  compinit -d ~/.config/zsh/zcompdump
done

compinit -C -d ~/.config/zsh/zcompdump

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

#  ┬ ┬┌─┐┬┌┬┐┬┌┐┌┌─┐  ┌┬┐┌─┐┌┬┐┌─┐
#  │││├─┤│ │ │││││ ┬   │││ │ │ └─┐
#  └┴┘┴ ┴┴ ┴ ┴┘└┘└─┘  ─┴┘└─┘ ┴ └─┘
expand-or-complete-with-dots() {
  echo -n "\e[31m…\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

#  ┬ ┬┬┌─┐┌┬┐┌─┐┬─┐┬ ┬
#  ├─┤│└─┐ │ │ │├┬┘└┬┘
#  ┴ ┴┴└─┘ ┴ └─┘┴└─ ┴ 
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

#  ┌─┐┌─┐┬ ┬  ┌─┐┌─┐┌─┐┬    ┌─┐┌─┐┌┬┐┬┌─┐┌┐┌┌─┐
#  ┌─┘└─┐├─┤  │  │ ││ ││    │ │├─┘ │ ││ ││││└─┐
#  └─┘└─┘┴ ┴  └─┘└─┘└─┘┴─┘  └─┘┴   ┴ ┴└─┘┘└┘└─┘
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt HIST_IGNORE_DUPS	   # Do not write events to history that are duplicates of previous events
setopt HIST_FIND_NO_DUPS   # When searching history don't display results already cycled through twice
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

#  ┌┬┐┬ ┬┌─┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐
#   │ ├─┤├┤   ├─┘├┬┘│ ││││├─┘ │ 
#   ┴ ┴ ┴└─┘  ┴  ┴└─└─┘┴ ┴┴   ┴
function dir_icon {
  if [[ "$PWD" == "$HOME" ]]; then
    echo "%B%F{black}%f%b"
  else
    echo "%B%F{yellow}%f%b"
  fi
}

PS1='%B%F{yellow}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{red}/.%F{red}/)%f%b '

#  ┌─┐┬  ┬ ┬┌─┐┬┌┐┌┌─┐
#  ├─┘│  │ ││ ┬││││└─┐
#  ┴  ┴─┘└─┘└─┘┴┘└┘└─┘


bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#  ┌─┐┬ ┬┌─┐┌┐┌┌─┐┌─┐  ┌┬┐┌─┐┬─┐┌┬┐┬┌┐┌┌─┐┬  ┌─┐  ┌┬┐┬┌┬┐┬  ┌─┐
#  │  ├─┤├─┤││││ ┬├┤    │ ├┤ ├┬┘│││││││├─┤│  └─┐   │ │ │ │  ├┤ 
#  └─┘┴ ┴┴ ┴┘└┘└─┘└─┘   ┴ └─┘┴└─┴ ┴┴┘└┘┴ ┴┴─┘└─┘   ┴ ┴ ┴ ┴─┘└─┘
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (kitty*|alacritty*|termite*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

#  ┌─┐┬  ┬┌─┐┌─┐
#  ├─┤│  │├─┤└─┐
#  ┴ ┴┴─┘┴┴ ┴└─┘
alias watt='watch -n 1 "cat /sys/class/drm/card1/device/hwmon/hwmon*/power1_average | awk '\''{print \$1/1000000 " W"}'\''"'
alias fan='watch -n 1 "cat /proc/acpi/ibm/fan"'
alias temp='watch -n 1 "sensors | grep -i '\''tctl\|edge'\''"'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'

alias update='sudo pacman -Syu'                  # Full system update
alias cleanpkg='sudo pacman -Rns $(pacman -Qdtq)'# Remove orphaned packages
alias clean='sudo pacman -Sc'                    # Clean package cache
alias pacs='pacman -Ss'                          # Search packages
alias paci='sudo pacman -S'                      # Install package
alias pacr='sudo pacman -Rns'                    # Remove package



alias yupdate='yay -Syu --devel --timeupdate'
alias yclean='yay -Yc'
alias ys='yay -Ss'     # Search
alias yi='yay -S'      # Install
alias yr='yay -Rns'    # Remove

alias vm-on="sudo systemctl start libvirtd.service"
alias vm-off="sudo systemctl stop libvirtd.service"

alias musica="ncmpcpp"

#alias ls='lsd -a --group-directories-first'
#alias ll='lsd -la --group-directories-first'

#  ┌─┐┬ ┬┌┬┐┌─┐  ┌─┐┌┬┐┌─┐┬─┐┌┬┐
#  ├─┤│ │ │ │ │  └─┐ │ ├─┤├┬┘ │ 
#  ┴ ┴└─┘ ┴ └─┘  └─┘ ┴ ┴ ┴┴└─ ┴ 
#$HOME/.local/bin/colorscript -r
#
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh




# 🎨 Catppuccin Mocha (Only Blue, Red, Green, Yellow)

# 🔷 Valid commands and builtins
ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#89b4fa'

# 🟢 Strings and variables
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#a6e3a1'

# 🟡 Options, separators, redirections
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#f9e2af'

# 🔴 Errors and unknown commands
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'

zmodload zsh/complist

# Enable tab completion menu selection
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Use Catppuccin Blue for selected item
export ZLS_COLORS="selected=fg=white,bg=#89b4fa"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/imsb/.lmstudio/bin"
# End of LM Studio CLI section


export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
fpath+=~/.zfunc; autoload -Uz compinit; compinit
export PATH="$HOME/.cargo/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/imsb/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/imsb/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/imsb/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/imsb/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# atuin shell history
eval "$(~/.local/bin/atuin init zsh --disable-up-arrow)"

# zsh auto-adopts vi mode when EDITOR/VISUAL contain 'vi' (nvim).
# Force emacs-style editing so Ctrl+A/E and Alt+B/F work as expected.
bindkey -e

# --- fzf: Ctrl+T paste path, Alt+C fuzzy cd ---
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
bindkey -M emacs '^r' atuin-search  # keep atuin as Ctrl+R (fzf binds it too)

# --- zoxide: smart `cd` by history ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# --- jump by whole shell words (paths stay together) ---
autoload -Uz select-word-style && select-word-style shell
