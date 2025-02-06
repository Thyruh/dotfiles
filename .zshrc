# Set keyboard layout options
setxkbmap -option caps:escape
setxkbmap -layout us,ru -option grp:alt_shift_toggle

export PROMPT=" %F{blue}%~%f ---> %F{red}thyruh%f: "

# Aliases
alias C++='cd ~/Architect/C++ && vim new.cpp'
alias py='cd ~/Architect/Python && vim new.py'
alias hsk='cd ~/Architect/Haskell && vim new.hs'
alias vg='cd ~/Architect/Go && vim new.go'
alias cls='clear && cd'
alias ..='cd ..'
alias ...='cd ../..'
alias 2.='cd ../../..'
alias 3.='cd ../../../..'
alias arc='cd ~/Architect && vim .'
alias sn='sudo shutdown now'
alias sr='sudo reboot'
alias bash='vim ~/.zshrc && source ~/.zshrc'
alias back='fg'

# Add paths to $PATH
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="/usr/local/go/bin:$PATH"
# Run startup commands

tmux
neofetch
ls -l


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$HOME/.local/opt/go/bin
