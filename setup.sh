#!/usr/bin/env bash

# Get current directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List of symbolic links
declare -A links
links[".config/kitty"]="$HOME/.config/kitty"
links[".config/wezterm"]="$HOME/.config/wezterm"
links[".config/terminator/config"]="$HOME/.config/terminator/config"
links[".bash_history"]="$HOME/.bash_history"
links[".gitconfig"]="$HOME/.gitconfig"
links[".config/nvim"]="$HOME/.config/nvim"
links[".vimrc"]="$HOME/.vimrc"
links[".vim"]="$HOME/.vim"
links[".tmux.conf"]="$HOME/.tmux.conf"
links[".tmux"]=$HOME/.tmux
links[".config/opencode/tui.json"]="$HOME/.config/opencode/tui.json"
links[".config/opencode/themes"]="$HOME/.config/opencode/themes"
links[".config/omp"]="$HOME/.config/omp"

# Make symbolic links
for src in "${!links[@]}"; do
    dest="${links[$src]}"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Removing $dest"
        rm -rf "$dest"
    fi
    ln -s "$SCRIPT_DIR/dotfiles/$src" "$dest"
    echo "Linked $dest -> $SCRIPT_DIR/dotfiles/$src"
done

# Config ownership for ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519_shororxor
chmod 644 ~/.ssh/id_ed25519_shororxor.pub
chmod 600 ~/.ssh/id_ed25519_bao
chmod 644 ~/.ssh/id_ed25519_bao.pub
chmod 600 ~/.ssh/config

# Export env variable for docker image build
export DOTFILES=$SCRIPT_DIR/dotfiles
