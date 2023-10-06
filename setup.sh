#!/usr/bin/env bash

remove_existing() {
    local path="$1"

    if [[ -L "$path" ]]; then
        # If the path is a symlink, remove it
        rm "$path"
        echo "Symlink removed: $path"
    elif [[ -d "$path" ]]; then
        # If the path is a directory, delete it recursively
        # rm -r "$path"
        mv "$path" "$path".old
        echo "Directory backed up: $path -> $path.bak"
    else
        # If the path is neither a symlink nor a directory, display an error message
        echo "Error: $path is not a symlink or directory"
    fi
}

remove_existing ~/.config/nvim
ln -fs $PWD/nvim ~/.config/nvim

remove_existing ~/.config/fish
ln -fs $PWD/fish ~/.config/fish

remove_existing ~/.config/kitty
ln -fs $PWD/kitty ~/.config/kitty

remove_existing ~/.config/starship.toml
ln -fs $PWD/starship.toml ~/.config/starship.toml

remove_existing ~/.config/lf
ln -fs $PWD/lf ~/.config/lf

remove_existing ~/.config/neofetch
ln -fs $PWD/neofetch ~/.config/neofetch

remove_existing ~/.config/lazygit
ln -fs $PWD/lazygit ~/.config/lazygit

remove_existing ~/.config/hypr
ln -fs $PWD/hypr ~/.config/hypr

remove_existing ~/.config/swaylock
ln -fs $PWD/swaylock ~/.config/swaylock

remove_existing ~/.config/waybar
ln -fs $PWD/waybar ~/.config/waybar
