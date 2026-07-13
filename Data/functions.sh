#!/bin/bash

#Funciones para la instalacion de las vainas

#Verificar el internet
verificar_internet() {
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo "No hay internet, conectate para poder continuar..."
    exit 1
else
    echo "Conectado a internet. Continuando la instalacion..."
fi
}

#Actualizando el sistema y agregando las repos
add_repos(){
    echo "Agregando repositorio de BlackArch"
     curl -O https://blackarch.org/strap.sh
     chmod +x strap.sh
     sudo ./strap.sh
     sudo pacman -Syu --noconfirm
     rm -rf strap.sh

}

#Agregando AUR, Paru
adding_helper() {
    if command -v paru &> /dev/null; then
        echo "Paru ya esta instalado, omitiendolo..."
        return
    fi
    echo "Instalando helper..."
    sudo pacman -S --needed base-devel --noconfirm
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf ~/paru
}

#Instalando Oh my zsh
oh_my_zsh() {
    echo "Instalando Oh My Zsh junto a algunos plugins..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
}

#Instalando Roblox
roblox_sober_install() {
    echo "Instalando Sober (Roblox adaptado para linux...)"
     flatpak install flathub org.vinegarhq.Sober 
}

#Agregando carpetas necesarias
makedirectory() {
    echo "Creando directorios necesarios"
    mkdir -p ~/Wallpapers ~/Descargas ~/Proyectos ~/Escuela ~/Proyectos/Python ~/Proyectos/Bash ~/.config/hypr
}

activar_servicios() {
    echo "Activando servicios de runit..."
    sudo ln -sf /etc/runit/sv/dbus /run/runit/service/
    sudo ln -sf /etc/runit/sv/elogind /run/runit/service/
    sudo ln -sf /etc/runit/sv/NetworkManager /run/runit/service/
    sudo ln -sf /etc/runit/sv/bluetoothd /run/runit/service/
}

download_wallpaper() {
    echo "Instalando Wallpapers basicos..."
    curl -L -o $HOME/Wallpapers/Wall-1.png https://w.wallhaven.cc/full/k8/wallhaven-k82p6d.png
    curl -L -o $HOME/Wallpapers/Wall-2.png https://w.wallhaven.cc/full/w5/wallhaven-w5m62x.png
    curl -L -o $HOME/Wallpapers/Wall-3.png https://w.wallhaven.cc/full/xe/wallhaven-xepp7d.jpg
    curl -L -o $HOME/Wallpapers/Wall-4.png https://w.wallhaven.cc/full/ml/wallhaven-ml2191.jpg
    curl -L -o $HOME/Wallpapers/Wall-5.png https://w.wallhaven.cc/full/5g/wallhaven-5g96j3.jpg
    curl -L -o $HOME/Wallpapers/Wall-6.png https://w.wallhaven.cc/full/3q/wallhaven-3q5k8y.png
    curl -L -o $HOME/Wallpapers/Wall-7.png https://w.wallhaven.cc/full/zp/wallhaven-zpo7dy.png
    curl -L -o $HOME/Wallpapers/Wall-8.png https://w.wallhaven.cc/full/9d/wallhaven-9djdkw.png
    curl -L -o $HOME/Wallpapers/Wall-9.png https://w.wallhaven.cc/full/kx/wallhaven-kx99jm.png
    curl -L -o $HOME/Wallpapers/Wall-10.png https://w.wallhaven.cc/full/7j/wallhaven-7jjo5e.jpg
}

dotfiles() {
    echo "Moviendo el archivo "hyprland.lua" al .config/hypr"
    mkdir -p ~/.config/hypr
    cp "$DIR/Data/hyprland.lua" ~/.config/hypr/
    
    echo "Copiando archivo de configuracion de Oh My Zsh..."
    cp "$DIR/Data/.zshrc" "$HOME"
}