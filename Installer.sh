#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "NO USES ROOT AL EJECUTAR EL ARCHIVO!!!"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DIR/Data/functions.sh"
source "$DIR/Data/list.sh"


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
clear
    echo "Instalando paquetes necesarios..."
    sudo pacman -S --needed "${paquetes_escenciales[@]}" --noconfirm
clear
    makedirectory
clear
    download_wallpaper
clear
    add_repos
clear
    adding_helper
clear
    echo "Iniciando con la instalacion de las herramientas"
    sudo pacman -S --needed "${herramientas[@]}" --noconfirm
clear
    activar_servicios
clear
    roblox_sober_install
clear
    oh_my_zsh
clear
    dotfiles
clear
else
    echo "saliendo de el script..."
    exit 0
fi

echo "La instalacion a terminado, todo a salido correctamente..."
read -p "Desea reiniciar el sistema? [y/n](recomendado)" reinicio_respuesta
reinicio_respuesta=${reinicio_respuesta,,}

if [[ "$reinicio_respuesta" == "y" ]]; then
    echo "Reiniciando el sistema en 5 segundos... (Cancela con CTRL+C)"
    sleep 10
    sudo reboot
else
    echo "Puedes reiniciar manualmente usando: "sudo reboot", ademas recuerde poner el comando: "chsh -s $(which zsh)""
fi
    
