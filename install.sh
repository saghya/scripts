#!/bin/sh

error() { printf "%s\n" "$1" >> ~/.install-errors.log; }

## SETUP ##
setup() {
    [ -f ~/.install-errors.log ] && rm ~/.install-errors.log

    # Make pacman colorful, concurrent downloads and Pacman eye-candy.
    sudo grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
    sudo sed -i "s/^#ParallelDownloads = 8$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf

    # Use all cores for compilation.
    sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

    # directory for source files
    mkdir -p ~/.local/src
}

## PACKAGES ##
packages() {
    PCKGS="base-devel clang gdb python ntfs-3g openssh xorg-server xorg-xwininfo xorg-xinit
        xorg-xprop xorg-xrandr xorg-xdpyinfo xclip xdotool xbindkeys xdg-utils xterm man-db
        man-pages polkit acpid pipewire pipewire-pulse pipewire-alsa pavucontrol pamixer wget
        udiskie alacritty noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji ttf-jetbrains-mono-nerd
        ttf-jetbrains-mono ttf-ubuntu-font-family dunst feh dash zsh zsh-autosuggestions maim neovim
        picom lxappearance gnome-themes-extra papirus-icon-theme kvantum kvantum-qt5 xorg-xset
        qt6ct ueberzugpp ranger pcmanfm zathura zathura-pdf-mupdf mpv eza inetutils ripgrep fd pyright
        bluez bluez-utils python-pygments networkmanager dnsmasq cups libhandy system-config-printer
        hplip xss-lock bash-language-server bear tree-sitter-cli ly unzip wireguard-tools wiremix firefox"
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

    AUR_PCKGS="breeze-snow-cursor-theme htop-vim dashbinsh networkmanager-dmenu-git
        dmenu-bluetooth catppuccin-gtk-theme-mocha catppuccin-gtk-theme-latte kvantum-theme-catppuccin-git
        zsh-fast-syntax-highlighting hplip-plugin xidlehook"
    for PCKG in $AUR_PCKGS; do
        yay --sudoloop --needed --noconfirm -S "$PCKG" || error "Error installing $PCKG"
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
        printf "%s\n"                                              \
               "#ifndef CONFIG_H"                                  \
               "#define CONFIG_H"                                  \
               ""                                                  \
               "#define DELIMITER              \"\""               \
               "#define MAX_BLOCK_OUTPUT_LENGTH 50"                \
               "#define CLICKABLE_BLOCKS         1"                \
               "#define LEADING_DELIMITER        0"                \
               "#define TRAILING_DELIMITER       0"                \
               ""                                                  \
               "#define BLOCKS(X) \\"                              \
               "	X(\"\", \"sb-volume\",            1,    1) \\" \
               "	X(\"\", \"sb-battery\",          30,    4) \\" \
               "	X(\"\", \"sb-network\",          15,    5) \\" \
               "	X(\"\", \"sb-bluetooth\",        15,    6) \\" \
               "	X(\"\", \"sb-date\",             10,    7) \\" \
               "	X(\"\", \"sb-powermenu_icon\",   10,    8) \\" \
               ""                                                  \
               "#endif // CONFIG_H" > config.h
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

    # afetch
    if git clone https://github.com/Saghya/afetch ~/.local/src/afetch; then
        cd ~/.local/src/afetch &&
        make
        sudo make install
    else
        error "Error installing afetch"
    fi
}

## LAPTOP ##
laptop() {
    L_PCKGS="brightnessctl tlp tlp-rdw tlpui batsignal libinput-gestures"
    for PCKG in $L_PCKGS; do
        sudo yay --sudoloop --needed --noconfirm -S "$PCKG" || error "Error installing $PCKG"
    done

    # tlp
    sudo systemctl enable tlp.service
    sudo systemctl enable NetworkManager-dispatcher.service
    sudo systemctl mask systemd-rfkill.service
    sudo systemctl mask systemd-rfkill.socket

    # set hibernation
    sudo grep -q '^[[]Login[]]' /etc/systemd/logind.conf ||
        printf "%s\n" "" "[Login]" | sudo tee -a /etc/systemd/logind.conf >/dev/null
    sudo grep -q '^[#[:space:]]*HandleLidSwitch=' /etc/systemd/logind.conf &&
        sudo sed -i 's|^[#[:space:]]*HandleLidSwitch=.*|HandleLidSwitch=suspend-then-hibernate|' /etc/systemd/logind.conf ||
        printf "%s\n" "HandleLidSwitch=suspend-then-hibernate" | sudo tee -a /etc/systemd/logind.conf >/dev/null
    sudo grep -q '^[#[:space:]]*HandleLidSwitchDocked=' /etc/systemd/logind.conf &&
        sudo sed -i 's|^[#[:space:]]*HandleLidSwitchDocked=.*|HandleLidSwitchDocked=ignore|' /etc/systemd/logind.conf ||
        printf "%s\n" "HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf >/dev/null
    sudo grep -q '^[#[:space:]]*HandleSuspendKey=' /etc/systemd/logind.conf &&
        sudo sed -i 's|^[#[:space:]]*HandleSuspendKey=.*|HandleSuspendKey=suspend-then-hibernate|' /etc/systemd/logind.conf ||
        printf "%s\n" "HandleSuspendKey=suspend-then-hibernate" | sudo tee -a /etc/systemd/logind.conf >/dev/null

    # Set hibernation timeout
    sudo grep -q '^[[]Sleep[]]' /etc/systemd/sleep.conf ||
        printf "%s\n" "" "[Sleep]" | sudo tee -a /etc/systemd/sleep.conf >/dev/null
    sudo grep -q '^[#[:space:]]*HibernateDelaySec=' /etc/systemd/sleep.conf &&
        sudo sed -i 's|^[#[:space:]]*HibernateDelaySec=.*|HibernateDelaySec=15min|' /etc/systemd/sleep.conf ||
        printf "%s\n" "HibernateDelaySec=15min" | sudo tee -a /etc/systemd/sleep.conf >/dev/null

    # touchpad
    sudo usermod -a -G input "$USER"
    sudo touch /etc/X11/xorg.conf.d/30-touchpad.conf
    printf "%s\n"                                     \
           "Section \"InputClass\""                   \
           "    Identifier \"mytouchpad\""            \
           "    Driver \"libinput\""                  \
           "    MatchIsTouchpad \"on\""               \
           "    Option \"NaturalScrolling\" \"true\"" \
           "    Option \"Tapping\" \"true\""          \
           "EndSection"                               |
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
    # acpi events
    sudo systemctl enable acpid.service
    sudo touch /etc/acpi/events/jack
    printf "%s\n"                            \
           "event=jack*"                     \
           "action=pkill -RTMIN+1 dwmblocks" |
    sudo tee /etc/acpi/events/jack

    # bluetooth
    sudo systemctl enable bluetooth.service

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

    # display manager
    sudo systemctl enable ly@tty2.service
    sudo systemctl disable getty@tty2.service
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

    # set tty theme
    sudo sed -i '/^GRUB_CMDLINE_LINUX="/ s/"$/ vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"/' /etc/default/grub

    # set grub timeout to 0
    sudo sed -i -E 's/^#?\s*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub

    # regenerate grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    # give the home directory to the user
    sudo chown -R "$USER" "$HOME"

    # install dwmblocks helper
    cd ~/.local/scripts/helpers/get-monitor-x &&
    make
    sudo make install

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

