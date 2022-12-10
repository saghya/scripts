#!/bin/sh

# dwm
sed -i "s/#EFF1F5/#1E1E2E/g" ~/.local/src/dwm/config.def.h
sed -i "s/#BCC0CC/#45475A/g" ~/.local/src/dwm/config.def.h
sed -i "s/#4C4F69/#CDD6F4/g" ~/.local/src/dwm/config.def.h
sed -i "s/#7287FD/#B4BEFE/g" ~/.local/src/dwm/config.def.h
cd ~/.local/src/dwm/ && sudo make clean install && killall dwm

# blocks
sed -i "s/#40A02B/#A6E3A1/g" ~/.local/scripts/blocks/*
sed -i "s/#1E66F5/#89B4FA/g" ~/.local/scripts/blocks/*
sed -i "s/#EA76CB/#F5C2E7/g" ~/.local/scripts/blocks/*
sed -i "s/#DF8E1D/#F9E2AF/g" ~/.local/scripts/blocks/*
sed -i "s/#D20F39/#F38BA8/g" ~/.local/scripts/blocks/*
sed -i "s/#179299/#94E2D5/g" ~/.local/scripts/blocks/*
killall dwmblocks && dwmblocks &

# gtk
sed -i "s/gtk-theme-name=.*/gtk-theme-name=\"Catppuccin-Mocha\"/g" ~/.gtkrc-2.0
sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"Papirus-Dark\"/g" ~/.gtkrc-2.0
sed -i "s/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Mocha/g" ~/.config/gtk-3.0/settings.ini
sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Dark/g" ~/.config/gtk-3.0/settings.ini

# qt
sed -i "s/theme=.*/theme=Catppuccin-Mocha-Lavender/g" ~/.config/Kvantum/kvantum.kvconfig

# alacritty
sed -i "s/~\/.config\/alacritty\/.*/~\/.config\/alacritty\/catppuccin\/catppuccin-mocha.yml/g" ~/.config/alacritty/alacritty.yml

# neovim
sed -i "s/local colorscheme =.*/local colorscheme = \"catppuccin-mocha\"/g" ~/.config/nvim/lua/user/colorscheme.lua

# dmenu
sed -i "s/#EFF1F5/#1E1E2E/g" ~/.local/src/dmenu/config.def.h
sed -i "s/#4C4F69/#CDD6F4/g" ~/.local/src/dmenu/config.def.h
sed -i "s/#7287FD/#B4BEFE/g" ~/.local/src/dmenu/config.def.h
cd ~/.local/src/dmenu/ && sudo make clean install && killall dmenu

# dunst
sed -i "s/#EFF1F5/#1E1E2E/g" ~/.config/dunst/dunstrc
sed -i "s/#4C4F69/#CDD6F4/g" ~/.config/dunst/dunstrc
sed -i "s/#7287FD/#B4BEFE/g" ~/.config/dunst/dunstrc
sed -i "s/#D20F39/#F38BA8/g" ~/.config/dunst/dunstrc
sed -i "s/#BCC0CC/#45475A/g" ~/.config/dunst/dunstrc
sed -i "s/Papirus-Light/Papirus-Dark/g" ~/.config/dunst/dunstrc
killall dunst

# zathura
sed -i "s/include .*/include .\/catppuccin\/catppuccin-mocha/g" ~/.config/zathura/zathurarc

