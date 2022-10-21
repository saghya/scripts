#!/bin/sh

error() { printf "%s\n" "$1" >> ~/.install-errors.log; }

## SETUP ##
setup() {
    [ -f ~/.install-errors.log ] && rm ~/.install-errors.log

    # Make pacman colorful, concurrent downloads and Pacman eye-candy.
    sudo grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
    sudo sed -i "s/^#ParallelDownloads = 8$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf

    # Use all cores for compilation.
    # sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

    # directory for source files
    mkdir -p ~/.local/src
}

## PACKAGES ##
packages() {
    PCKGS="base-devel clang gdb python ntfs-3g openssh xorg-server xorg-xwininfo xorg-xinit
        xorg-xprop xorg-xrandr xorg-xdpyinfo xclip xdotool xbindkeys xdg-utils xterm man-db
        man-pages polkit acpid pipewire pipewire-pulse pipewire-alsa pavucontrol pamixer wget
        udiskie alacritty noto-fonts noto-fonts-cjk noto-fonts-extra ttf-font-awesome ttf-jetbrains-mono
        ttf-ubuntu-font-family dunst feh dash zsh zsh-autosuggestions maim neovim picom lxappearance
        gtk-engine-murrine gnome-themes-extra arc-gtk-theme papirus-icon-theme kvantum qt5ct qt6ct
        ueberzug ranger pcmanfm zathura zathura-pdf-mupdf mpv exa inetutils ripgrep fd pyright bluez
        bluez-utils python-pygments networkmanager dnsmasq cups libhandy system-config-printer hplip"
    sudo pacman --noconfirm -Syyu
    for PCKG in $PCKGS; do
        sudo pacman --needed --noconfirm -S "$PCKG" || error "Error installing $PCKG"
    done

    ## AUR PACKAGES ##
    # yay
    if git clone https://aur.archlinux.org/yay-bin.git ~/.local/src/yay-bin; then
        cd ~/.local/src/yay-bin &&
        makepkg --noconfirm -si
    else
        error "Error installing yay"
    fi

    AUR_PCKGS="google-chrome breeze-snow-cursor-theme htop-vim ly dashbinsh networkmanager-dmenu-git
        dmenu-bluetooth kvantum-theme-arc zsh-fast-syntax-highlighting hplip-plugin"
    for PCKG in $AUR_PCKGS; do
        yay --needed --noconfirm -S "$PCKG" || error "Error installing $PCKG"
    done
}

## GIT PACKAGES ##
git_packages() {
    # dotfiles
    if git clone --bare https://github.com/saghya/dotfiles ~/.local/dotfiles; then
        /usr/bin/git --git-dir="$HOME"/.local/dotfiles/ --work-tree="$HOME" checkout
    else
        error "Error installing dotfiles"
    fi

    # dwm
    if git clone https://github.com/saghya/dwm ~/.local/src/dwm; then
        cd ~/.local/src/dwm &&
        make
        sudo make install
    else
        error "Error installing dwm"
    fi

    # dwmblocks-async
    if git clone https://github.com/UtkarshVerma/dwmblocks-async ~/.local/src/dwmblocks-async; then
        cd ~/.local/src/dwmblocks-async &&
        printf "%s\n"                                          \
               "#define CMDLENGTH 50"                          \
               "#define DELIMITER \"^d^ |\""                   \
               "#define CLICKABLE_BLOCKS"                      \
               ""                                              \
               "const Block blocks[] = {                     " \
               "	BLOCK(\"sb-volume\",            1,    1)," \
               "	BLOCK(\"sb-memory\",            5,    2)," \
               "	BLOCK(\"sb-cpu\",               5,    3)," \
               "	BLOCK(\"sb-battery\",          30,    4)," \
               "	BLOCK(\"sb-network\",          15,    5)," \
               "	BLOCK(\"sb-bluetooth\",        15,    6)," \
               "	BLOCK(\"sb-date\",             10,    7)," \
               "	BLOCK(\"sb-powermenu_icon\",    0,    8)," \
               "};" > config.h
        make
        sudo make install
    else
        error "Error installing dwmblocks-async"
    fi

    # dmenu
    if git clone https://github.com/saghya/dmenu ~/.local/src/dmenu; then
        cd ~/.local/src/dmenu &&
        make
        sudo make install
    else
        error "Error installing dmenu"
    fi

    # slock
    if git clone https://git.suckless.org/slock ~/.local/src/slock && cd ~/.local/src/slock &&
        wget https://tools.suckless.org/slock/patches/dwmlogoandblurscreen/slock-dwmlogoandblurscreen-1.0.diff; then
        git apply slock-dwmlogoandblurscreen-1.0.diff
        sed -i "s/nogroup/$USER/g" config.def.h 
        sed -i "s/2d2d2d/#b3c2f2/g" config.def.h
        sed -i "s/#005577/#69a2ff/g" config.def.h
        sed -i "s/#CC3333/#eb4034/g" config.def.h
        sed -i '/^\s*XBell/d' slock.c # Remove annoying bell
        make
        sudo make install
    else
        error "Error installing slock"
    fi

    # afetch
    if git clone https://github.com/Saghya/afetch ~/.local/src/afetch; then
        cd ~/.local/src/afetch &&
        make
        sudo make install
    else
        error "Error installing afetch"
    fi

    # grub-theme
    if git clone https://github.com/vinceliuice/grub2-themes ~/.local/src/grub2-themes; then
        sudo ~/.local/src/grub2-themes/install.sh -b -t tela
    else
        error "Error installing grub theme"
    fi
}

## LAPTOP ##
laptop() {
    L_PCKGS="xorg-xbacklight tlp tlp-rdw tlpui batsignal libinput-gestures"
    for PCKG in $L_PCKGS; do
        sudo yay --needed --noconfirm -S "$PCKG" || error "Error installing $PCKG"
    done

    # tlp
    sudo systemctl enable tlp.service
    sudo systemctl enable NetworkManager-dispatcher.service
    sudo systemctl mask systemd-rfkill.service
    sudo systemctl mask systemd-rfkill.socket

    # touchpad
    sudo usermod -a -G input "$USER"
    sudo touch /etc/X11/xorg.conf.d/30-touchpad.conf
    printf "%s\n"                                     \
           "Section \"InputClass\""                   \
           "    Identifier \"devname\""               \
           "    Driver \"libinput\""                  \
           "    Option \"Tapping\" \"on\""            \
           "    Option \"NaturalScrolling\" \"true\"" \
           "EndSection\n"                             |
    sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf
    
    # acpi events
    sudo touch /etc/acpi/events/ac_adapter
    printf "%s\n"                            \
           "event=ac_adapter"                \
           "action=pkill -RTMIN+4 dwmblocks" |
    sudo tee /etc/acpi/events/ac_adapter
    
    # brightness and video group
    sudo usermod -a -G video "$USER"
    sudo touch /etc/udev/rules.d/backlight.rules
    echo "ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"acpi_video0\", GROUP=\"video\", MODE=\"0664\"" |
    sudo tee /etc/udev/rules.d/backlight.rules
}

services() {
    # display manager
    sudo systemctl enable ly.service
    printf "%s\n"                                                                                       \
           "term_reset_cmd = /usr/bin/tput reset; /usr/bin/printf '\%b' '\\e]P0222430\\e]P769a2ff\\ec'" \
           "blank_password = true"                                                                      |
    sudo tee /etc/ly/config.ini
    if [ "$(sed "8q;d" /lib/systemd/system/ly.service)" != "ExecStartPre=/usr/bin/printf '%%b' '\e]P0222430\e]P769a2ff\ec'" ]; then
        sudo sed -i "8i ExecStartPre=/usr/bin/printf '%%b' '\\\e]P0222430\\\e]P769a2ff\\\ec'" /lib/systemd/system/ly.service
    fi

    # acpi events
    sudo systemctl enable acpid.service
    sudo touch /etc/acpi/events/jack
    printf "%s\n"                            \
           "event=jack*"                     \
           "action=pkill -RTMIN+1 dwmblocks" |
    sudo tee /etc/acpi/events/jack

    # bluetooth
    sudo systemctl enable bluetooth.service

    # slock
    sudo touch /etc/systemd/system/slock@.service
    printf "%s\n"                                               \
           "[Unit]"                                             \
           "Description=Lock X session using slock for user %i" \
           "Before=sleep.target"                                \
           "Before=suspend.target"                              \
           ""                                                   \
           "[Service]"                                          \
           "User=%i"                                            \
           "Environment=DISPLAY=:0"                             \
           "ExecStartPre=/usr/bin/xset dpms force suspend"      \
           "ExecStart=/usr/local/bin/slock"                     \
           ""                                                   \
           "[Install]"                                          \
           "WantedBy=sleep.target"                              \
           "WantedBy=suspend.target"                            |
    sudo tee /etc/systemd/system/slock@.service
    sudo systemctl enable slock@"$USER".service

    # network
    sudo touch /etc/NetworkManager/conf.d/dns.conf
    printf "%s\n"        \
           "[main]"      \
           "dns=dnsmasq" |
    sudo tee /etc/NetworkManager/conf.d/dns.conf
    sudo nmcli general reload
    sudo touch /etc/NetworkManager/dnsmasq.d/dnsmasq.conf
    printf "%s\n"            \
           "cache-size=1000" \
           "no-resolv"       \
           "server=8.8.8.8"  \
           "server=8.8.4.4"  |
    sudo tee /etc/NetworkManager/dnsmasq.d/dnsmasq.conf
    sudo systemctl enable NetworkManager.service

    # cups
    sudo systemctl enable cups.socket
    sudo usermod -a -G lp "$USER"
}

finishing_touches() {
    # dwm login session
    sudo mkdir -p /usr/share/xsessions
    sudo touch /usr/share/xsessions/dwm.desktop
    printf "%s\n"                           \
           "[Desktop Entry]"                \
           "Encoding=UTF-8"                 \
           "Name=dwm"                       \
           "Comment=Dynamic window manager" \
           "Exec=startdwm"                  \
           "Icon=dwm"                       \
           "Type=XSession"                  |
    sudo tee /usr/share/xsessions/dwm.desktop

    # default text editor
    sudo mkdir -p ~/.local/share/applications
    sudo touch ~/.local/share/applications/nvim.desktop
    printf "%s\n"                           \
           "[Desktop Entry]"                \
           "Name=Neovim Text Editor"        \
           "Comment=Edit text files"        \
           "Exec=nvim"                      \
           "Terminal=true"                  \
           "Type=Application"               \
           "Icon=terminal"                  \
           "Categories=Utility;TextEditor;" \
           "StartupNotify=true"             \
           "MimeType=text/plain;"
    xdg-mime default nvim.desktop text/plain

    # default pdf viewer
    xdg-mime default org.pwmt.zathura.desktop application/pdf

    # default shell
    sudo usermod -s /usr/bin/zsh "$USER"

    # relinking /bin/sh
    sudo ln -sfT dash /usr/bin/sh

    # set cursor theme
    sudo sed -i '$ d' /usr/share/icons/default/index.theme
    printf "Inherits=Breeze_Snow" | sudo tee -a /usr/share/icons/default/index.theme

    # errors
    if [ -f ~/.install-errors.log ]; then
        printf "\033[0;31m\tERRORS:\n#######################\n"
        cat ~/.install-errors.log
        printf "#######################\033[0m\n"
    else
        sudo reboot
    fi
}

main() {
    setup
    packages
    git_packages

    # laptop specific packages and settings
    read -r CHASSIS_TYPE < /sys/class/dmi/id/chassis_type
    if [ "$CHASSIS_TYPE" = 9 ] || [ "$CHASSIS_TYPE" = 10 ]; then
        laptop
    fi

    services
    finishing_touches
}

main

