#!/bin/bash

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

# remove_existing /tmp/.config/test
remove_existing ~/.config/nvim
remove_existing ~/.config/fish
remove_existing ~/.config/kitty
remove_existing ~/.config/starship.toml
remove_existing ~/.config/lf

ln -fs $PWD/nvim ~/.config/nvim
ln -fs $PWD/fish ~/.config/fish
ln -fs $PWD/kitty ~/.config/kitty
ln -fs $PWD/starship.toml ~/.config/starship.toml
ln -fs $PWD/lf ~/.config/lf
