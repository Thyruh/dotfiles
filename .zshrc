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
alias ...='cd ../..'
alias 2.='cd ../../..'
alias 3.='cd ../../../..'
alias :q='nvim .'
alias cal='ncal'

# PATH (clean, additive)
export PATH=/home/thyruh/bin:/home/thyruh/.cargo/bin:/home/thyruh/.dub/packages/dcd/0.16.2/dcd:/home/thyruh/.local/bin:/home/thyruh/.local/opt/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/home/thyruh/dlang/dmd-2.112.0/linux/bin64
# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Keyboard / shell
set -o vi
setxkbmap -option caps:escape

clear

alias discord='flatpak run com.discordapp.Discord'
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"
export PATH=$HOME/.nimble/bin:$PATH
