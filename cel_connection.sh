#!/data/data/com.termux/files/usr/bin/bash

set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"


clear

echo -e "${GREEN}"
echo "=================================="
echo "   Termux SSH Auto Provisioner"
echo "=================================="
echo -e "${RESET}"


echo "[+] Actualizando paquetes..."
pkg update -y
pkg upgrade -y


echo
echo "[+] Instalando dependencias..."

pkg install -y \
openssh \
termux-tools \
net-tools \
procps


echo
echo "[+] Configurando acceso al almacenamiento..."

termux-setup-storage || true

sleep 3


echo
echo "[+] Generando claves SSH..."

ssh-keygen -A


echo
echo "=================================="
echo " Crea la contraseña SSH"
echo "=================================="

passwd


echo
echo "[+] Reiniciando SSH..."

pkill sshd 2>/dev/null || true

sleep 2

sshd


sleep 3


USER_TERMUX=$(whoami)

IP=$(ip addr show wlan0 2>/dev/null \
| grep "inet " \
| awk '{print $2}' \
| cut -d/ -f1)


PORT=8022


echo
echo "[+] Verificando SSH..."

if pgrep sshd >/dev/null; then

    echo -e "${GREEN}SSH ACTIVO${RESET}"

else

    echo -e "${RED}SSH NO INICIADO${RESET}"
    exit 1

fi


if [ -z "$IP" ]; then

    echo -e "${YELLOW}No se pudo detectar IP WiFi${RESET}"

    IP="IP_NO_DETECTADA"

fi


cat > ~/ssh_connection.txt <<EOF
USER=$USER_TERMUX
IP=$IP
PORT=$PORT
SSH=$USER_TERMUX@$IP
EOF


echo
echo "=================================="
echo -e "${GREEN} CONFIGURACION COMPLETA ${RESET}"
echo "=================================="

echo
echo "Usuario:"
echo "$USER_TERMUX"

echo
echo "IP:"
echo "$IP"

echo
echo "Puerto:"
echo "$PORT"

echo
echo "Conexion:"
echo "ssh -p $PORT $USER_TERMUX@$IP"

echo
echo "Archivo guardado:"
echo "~/ssh_connection.txt"

echo
echo "=================================="
