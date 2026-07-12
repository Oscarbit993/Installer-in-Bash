#!/bin/bash

paquetes_escenciales=(
git
neovim
fzf
bat
base-devel
firefox
hyprland
nerd-fonts
zsh
wget
torbrowser-launcher
flatpak
kitty
unzip
starship
btop
htop
openvpn
man
yazi
bluez
bluez-utils
elogind-runit
dbus-runit
networkmanager-runit
rofi
nautilus
mako
hyprshot
fastfetch
pipewire
pipewire-alsa
pipewire-pulse
pipewire-jack
wireplumber
playerctl
spotify-launcher
)

herramientas=(
nmap
burpsuite
openssh
theharvester
wireshark-qt
whatweb
tmux
python
python3
)


#Funciones para la instalacion de las vainas
#Verificar el internet
verificar_internet () {
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo "No hay internet, conectate para poder continuar..."
    exit 1
else
    echo "Conectado a internet. Continuando la instalacion..."
fi
}
#Actualizando el sistema y agregando las repos
add_repos () {
    echo "Agregando repositorio de BlackArch"
     curl -O https://blackarch.org/strap.sh
     chmod +x strap.sh
     sudo ./strap.sh
     sudo pacman -Syu
     rm -rf strap.sh

}
#Agregando AUR, Paru
adding_helper () {
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
}
#Instalando Roblox
roblox_sober_install () {
    echo "Instalando Sober (Roblox adaptado para linux...)"
     flatpak install flathub org.vinegarhq.Sober 
}
#Agregando carpetas necesarias
makedirectory () {
    echo "Creando directorios necesarios"
    mkdir -p ~/Wallpapers ~/Descargas ~/Proyectos ~/Escuela ~/Proyectos/Python ~/Proyectos/Bash ~/.config/hypr
}

oh_my_zsh () {
    echo "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
    echo "Cambiando la shell..."
    chsh -s "$(which zsh)"
}

activar_servicios () {
    echo "Activando servicios de runit..."
    sudo ln -sf /etc/runit/sv/dbus /run/runit/service/
    sudo ln -sf /etc/runit/sv/elogind /run/runit/service/
    sudo ln -sf /etc/runit/sv/NetworkManager /run/runit/service/
    sudo ln -sf /etc/runit/sv/bluetoothd /run/runit/service/
}

dotfiles () {
    echo "Moviendo el archivo "hyprland.lua" al .config/hypr"
    cp ~/Installer-in-Bash/hyprland.lua ~/.config/hypr/
}

if [ "$EUID" -eq 0 ]; then
    echo "NO USES ROOT AL EJECUTAR EL ARCHIVO!!!"
    exit 1
fi

cat << 'EOF'
   ___       __  _        ____         __       ____           _____            _ __  _ 
  / _ | ____/ /_(_)_ __  /  _/__  ___ / /____ _/ / /__ ____  _/_/ _ \__ _____  (_) /_| |
 / __ |/ __/ __/ /\ \ / _/ // _ \(_-</ __/ _ `/ / / -_) __/ / // , _/ // / _ \/ / __// /
/_/ |_/_/  \__/_//_\_\ /___/_//_/___/\__/\_,_/_/_/\__/_/   / //_/|_|\_,_/_//_/_/\__//_/ 
                                                           |_|                    /_/   
EOF

echo "Bienvenido al sistema de instalacion de Artix Linux (Con runit)"
read -p "Desea continuar? [Y/n]: " iniciar_instalacion
iniciar_instalacion=${iniciar_instalacion:-y}
iniciar_instalacion=${iniciar_instalacion,,}

if [[ "$iniciar_instalacion" == "y" ]]; then
    echo "Iniciando instalacion..."
    echo "Verificando conexion, espere..."
    verificar_internet
    echo "Actualizando el sistema, espere..."
    sudo pacman -Syu
    echo "Instalando paquetes necesarios..."
    sudo pacman -S --needed "${paquetes_escenciales[@]}" --noconfirm
    clear
    add_repos
    adding_helper
    echo "Iniciando con la instalacion de las herramientas"
    sudo pacman -S --needed "${herramientas[@]}" --noconfirm
    makedirectory
    oh_my_zsh
    activar_servicios
    roblox_sober_install
    dotfiles
else
    echo "saliendo de el script..."
    exit 0
fi

echo "La instalacion a terminado, todo a salido correctamente..."
read -p "Desea reiniciar el sistema? [y/n](recomendado)" reinicio_respuesta
reinicio_respuesta=${reinicio_respuesta,,}

if [[ "$reinicio_respuesta" == "y" ]]; then
    echo "Reiniciando el sistema en 5 segundos... (Cancela con CTRL+C)"
    sleep 5
    sudo reboot
else
    echo "Puedes reiniciar manualmente usando: "sudo reboot""
fi
    
