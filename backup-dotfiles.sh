#!/usr/bin/env bash

DESTINATION="$HOME/dotfiles"

# List of files and directories to copy
FILES=(
    "notes.md"
    "bin/"
    ".zshrc"
    ".tmux/"
    ".tmux.conf"
    ".emacs"
    ".emacs.d"
    ".config/nvim"
    ".config/i3"
    "backup-dotfiles.sh"
    "gh-dump.py"
)

mkdir -p "$DESTINATION" 

for f in "${FILES[@]}"; do
    SRC="$HOME/$f"
    DEST="$DESTINATION/$f"
    mkdir -p "$(dirname "$DEST")"
    if [ -d "$SRC" ]; then
        mkdir -p "$DEST"
        cp -r "$SRC/"* "$DEST/"
    else
        cp "$SRC" "$DEST"
    fi
done

find "$DESTINATION" -mindepth 2 -type d -name ".git" -exec rm -rf {} + 2>/dev/null
find "$DESTINATION" -mindepth 2 -type f \( -name ".gitignore" -o -name ".gitattributes" -o -name ".gitmodules" \) -exec rm -f {} +
