#!/usr/bin/env bash

source "$(dirname "$0")/utils.sh"

mostrar_interfaces() {
    echo "Interfaces Disponibles:"
    ip -brief link show
}

cambiar_estado() {
    mostrar_interfaces
    read -p "Nombre de la interfaz (ej. eth0, wlan0): " interfaz
    read -p "Acción (up/down): " accion
    
    sudo ip link set "$interfaz" "$accion" && echo "Interfaz $interfaz ahora está $accion."
}

conectar_wifi() {
    echo "Escaneando redes cercanas."
    nmcli device wifi list
    read -p "SSID de la red: " ssid
    read -p "Contraseña: " password
    
    sudo nmcli device wifi connect "$ssid" password "$password"
}

configurar_ip() {
    read -p "Interfaz a configurar: " interfaz
    echo "1) Dinámica (DHCP)"
    echo "2) Estática"
    read -p "Opción: " tipo
    
    if [ "$tipo" == "1" ]; then
        sudo nmcli con add type ethernet ifname "$interfaz" con-name "DHCP-$interfaz" ipv4.method auto
    else
        read -p "IP (ej. 192.168.1.50/24): " ip_addr
        read -p "Gateway (ej. 192.168.1.1): " gateway
        read -p "DNS (ej. 8.8.8.8): " dns
        
        sudo nmcli con add type ethernet ifname "$interfaz" con-name "Static-$interfaz" \
            ipv4.addresses "$ip_addr" ipv4.gateway "$gateway" ipv4.dns "$dns" ipv4.method manual
    fi
    sudo nmcli con up id "$(nmcli -g NAME con show --active | grep $interfaz || echo "Static-$interfaz")"
}

menu() {
    clear
    echo " Gestor de Red "
    echo "1. Mostrar interfaces"
    echo "2. Encender/Apagar interfaz"
    echo "3. Conectar a Wi-Fi"
    echo "4. Configurar IP (DHCP/Estática)"
    echo "5. Salir"
    read -p "Seleccione una opción: " opt
    
    case $opt in
        1) mostrar_interfaces ;;
        2) cambiar_estado ;;
        3) conectar_wifi ;;
        4) configurar_ip ;;
        5) exit 0 ;;
        *) echo "Opción no válida" ;;
    esac
    read -p "Presione Enter para continuar..."
    menu
}

if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse con sudo."
   exit 1
fi

menu
