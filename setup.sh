#!/bin/bash

rm ~/.config/nvim
rm ~/.config/fish
rm ~/.config/kitty
rm ~/.config/starship.toml
rm ~/.config/lf

ln -fs $PWD/nvim ~/.config/nvim
ln -fs $PWD/fish ~/.config/fish
ln -fs $PWD/kitty ~/.config/kitty
ln -fs $PWD/starship.toml ~/.config/starship.toml
ln -fs $PWD/lf ~/.config/lf
