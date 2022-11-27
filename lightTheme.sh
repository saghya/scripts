#!/bin/sh

# dwm
sed -i "s/#1E1E2E/#EFF1F5/g" ~/.local/src/dwm/config.def.h
sed -i "s/#45475A/#BCC0CC/g" ~/.local/src/dwm/config.def.h
sed -i "s/#CDD6F4/#4C4F69/g" ~/.local/src/dwm/config.def.h
sed -i "s/#B4BEFE/#7287FD/g" ~/.local/src/dwm/config.def.h
cd ~/.local/src/dwm/ && sudo make clean install && killall dwm

# blocks
sed -i "s/#A6E3A1/#40A02B/g" ~/.local/scripts/blocks/*
sed -i "s/#89B4FA/#1E66F5/g" ~/.local/scripts/blocks/*
sed -i "s/#F5C2E7/#EA76CB/g" ~/.local/scripts/blocks/*
sed -i "s/#F9E2AF/#DF8E1D/g" ~/.local/scripts/blocks/*
sed -i "s/#F38BA8/#D20F39/g" ~/.local/scripts/blocks/*
sed -i "s/#94E2D5/#179299/g" ~/.local/scripts/blocks/*
killall dwmblocks && dwmblocks &

# gtk
sed -i "s/gtk-theme-name=.*/gtk-theme-name=\"Catppuccin-Latte-Grey\"/g" ~/.gtkrc-2.0
sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"Papirus-Light\"/g" ~/.gtkrc-2.0
sed -i "s/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Latte-Grey/g" ~/.config/gtk-3.0/settings.ini
sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Light/g" ~/.config/gtk-3.0/settings.ini

# qt
sed -i "s/theme=.*/theme=Catppuccin-Latte-Lavender/g" ~/.config/Kvantum/kvantum.kvconfig

# alacritty
sed -i "s/~\/.config\/alacritty\/.*/~\/.config\/alacritty\/catppuccin\/catppuccin-latte.yml/g" ~/.config/alacritty/alacritty.yml

# neovim
sed -i "s/local colorscheme =.*/local colorscheme = \"catppuccin-latte\"/g" ~/.config/nvim/lua/user/colorscheme.lua

# dmenu
sed -i "s/#1E1E2E/#EFF1F5/g" ~/.local/src/dmenu/config.def.h
sed -i "s/#CDD6F4/#4C4F69/g" ~/.local/src/dmenu/config.def.h
sed -i "s/#B4BEFE/#7287FD/g" ~/.local/src/dmenu/config.def.h
cd ~/.local/src/dmenu/ && sudo make clean install && killall dmenu

# dunst
sed -i "s/#1E1E2E/#EFF1F5/g" ~/.config/dunst/dunstrc
sed -i "s/#CDD6F4/#4C4F69/g" ~/.config/dunst/dunstrc
sed -i "s/#B4BEFE/#7287FD/g" ~/.config/dunst/dunstrc
sed -i "s/#F38BA8/#D20F39/g" ~/.config/dunst/dunstrc
sed -i "s/#45475A/#BCC0CC/g" ~/.config/dunst/dunstrc
sed -i "s/Papirus-Dark/Papirus-Light/g" ~/.config/dunst/dunstrc
killall dunst

# zathura
sed -i "s/include .*/include .\/catppuccin\/catppuccin-latte/g" ~/.config/zathura/zathurarc

