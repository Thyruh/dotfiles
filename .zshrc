export PROMPT="%F{blue}%~%f ———> %F{red}thyruh%f: "

# Aliases
alias cls='clear && cd'
alias ..='cd ..'
alias ...='cd ../..'
alias 2.='cd ../../..'
alias 3.='cd ../../../..'
alias :q='nvim .'
alias cal='ncal'
alias raylib='cd /mnt/c/Users/yuzef/projects/raylib && :q'

# PATH (clean, additive)
export PATH=/home/thyruh/bin:/home/thyruh/.cargo/bin:/home/thyruh/.dub/packages/dcd/0.16.2/dcd:/home/thyruh/.local/bin:/home/thyruh/.local/opt/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/home/thyruh/dlang/dmd-2.112.0/linux/bin64
# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# Keyboard / shell
set -o vi
setxkbmap -option caps:escape

tmux a
tmux
clear

alias discord='flatpak run com.discordapp.Discord'
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"
export PATH=$HOME/.nimble/bin:$PATH
