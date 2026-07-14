# Prompt magic
autoload -Uz vcs_info add-zsh-hook
_prompt_git_or_fallback() {
    vcs_info
    local branch
    if [[ $(git rev-parse --is-bare-repository 2>/dev/null) == "true" && \
          $(git rev-parse --absolute-git-dir 2>/dev/null) == "$PWD" ]]; then
        PROMPT='%F{38}%1d%f ———> %F{red}thyruh%f: '
    elif [[ -n $vcs_info_msg_0_ ]]; then
        branch="${vcs_info_msg_0_#'git:('}"
        branch="${branch%')'}"
        if [[ "${PWD:t}" == "$branch" ]]; then
            PROMPT='%F{38}%1d%f ———> %F{red}thyruh%f: '
        else
            PROMPT='%F{38}%1d%f %F{blue}git:(%f%F{red}'"${branch}"'%f%F{blue})%f: '
        fi
    else
        PROMPT='%F{38}%1d%f ———> %F{red}thyruh%f: '
    fi
}

add-zsh-hook precmd _prompt_git_or_fallback
zstyle ':vcs_info:git:*' formats 'git:(%b)'
zstyle ':vcs_info:git:*' actionformats 'git:(%b|%a)'
setopt PROMPT_SUBST

# Aliases
alias logout='dm-tool switch-to-greeter'
alias cls='clear && cd'
alias ..='cd ..'
alias -- -='cd -'
alias ...='cd ../..'
alias 2.='cd ../../..'
alias 3.='cd ../../../..'
alias :q='nvim .'

# xrandr --output HDMI-2 --primary --auto --pos 0x0 --output eDP-1 --auto --pos 50x-768
# xrandr --output eDP-1 --auto --pos 0x-768 --output HDMI-2 --primary --auto --pos 0x0

# PATH (clean, padditive)
export PATH="$PATH:/home/thyruh/bin"
# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
feh --bg-max /home/thyruh/wallpaper/retro-pyramid-synthwave.jpg
setxkbmap -layout "us,ru" -option "grp:shifts_toggle, caps:ctrl_modifier"
# Keyboard / shell
set -o emacs

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.config/.zsh_history

export PATH=$HOME/.nimble/bin:$PATH
clear
