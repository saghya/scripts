#!/bin/sh

# dwm
sed -i "s/#0E0E1E/#EFF1F5/g" ~/.local/src/dwm/config.def.h
sed -i "s/#45475A/#BCC0CC/g" ~/.local/src/dwm/config.def.h
sed -i "s/#EDF6FF/#4C4F69/g" ~/.local/src/dwm/config.def.h
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
sed -i "s/gtk-theme-name=.*/gtk-theme-name=\"Catppuccin-Latte-Standard-Blue-Light\"/g" ~/.gtkrc-2.0
sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"Papirus-Light\"/g" ~/.gtkrc-2.0
sed -i "s/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Latte-Standard-Blue-Light/g" ~/.config/gtk-3.0/settings.ini
sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Light/g" ~/.config/gtk-3.0/settings.ini

# qt
sed -i "s/theme=.*/theme=Catppuccin-Latte-Lavender/g" ~/.config/Kvantum/kvantum.kvconfig

# alacritty
sed -i "s/import = .*/import = [\"~\/.config\/alacritty\/catppuccin\/catppuccin-latte.toml\"]/g" ~/.config/alacritty/alacritty.toml

# neovim
sed -i "s/local colorscheme =.*/local colorscheme = \"catppuccin-latte\"/g" ~/.config/nvim/lua/user/colorscheme.lua

# dmenu
sed -i "s/#0E0E1E/#EFF1F5/g" ~/.local/src/dmenu/config.def.h
sed -i "s/#EDF6FF/#4C4F69/g" ~/.local/src/dmenu/config.def.h
sed -i "s/#B4BEFE/#7287FD/g" ~/.local/src/dmenu/config.def.h
cd ~/.local/src/dmenu/ && sudo make clean install && killall dmenu

# dunst
sed -i "s/#0E0E1E/#EFF1F5/g" ~/.config/dunst/dunstrc
sed -i "s/#EDF6FF/#4C4F69/g" ~/.config/dunst/dunstrc
sed -i "s/#B4BEFE/#7287FD/g" ~/.config/dunst/dunstrc
sed -i "s/#F38BA8/#D20F39/g" ~/.config/dunst/dunstrc
sed -i "s/#45475A/#BCC0CC/g" ~/.config/dunst/dunstrc
sed -i "s/Papirus-Dark/Papirus-Light/g" ~/.config/dunst/dunstrc
killall dunst

# zathura
sed -i "s/include .*/include .\/catppuccin\/catppuccin-latte/g" ~/.config/zathura/zathurarc

# scripts
sed -i "s/Papirus-Dark/Papirus-Light/g" ~/.local/scripts/volumeControl.sh
sed -i "s/Papirus-Dark/Papirus-Light/g" ~/.local/scripts/brightnessControl.sh

# Xresources
sed -i "s/#1E1E2E/#EFF1F5/g" ~/.config/X11/Xresources
sed -i "s/#CDD6F4/#4C4F69/g" ~/.config/X11/Xresources
sed -i "s/#45475A/#5C5F77/g" ~/.config/X11/Xresources
sed -i "s/#585B70/#6C6F85/g" ~/.config/X11/Xresources
sed -i "s/#F38BA8/#D20F39/g" ~/.config/X11/Xresources
sed -i "s/#A6E3A1/#40A02B/g" ~/.config/X11/Xresources
sed -i "s/#F9E2AF/#DF8E1D/g" ~/.config/X11/Xresources
sed -i "s/#89B4FA/#1E66F5/g" ~/.config/X11/Xresources
sed -i "s/#F5C2E7/#EA76CB/g" ~/.config/X11/Xresources
sed -i "s/#94E2D5/#179299/g" ~/.config/X11/Xresources
sed -i "s/#BAC2DE/#ACB0BE/g" ~/.config/X11/Xresources
sed -i "s/#A6ADC8/#BCC0CC/g" ~/.config/X11/Xresources
xrdb ~/.config/X11/Xresources

