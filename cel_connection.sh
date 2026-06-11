#!/data/data/com.termux/files/usr/bin/bash

set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"


clear

echo -e "${GREEN}"
echo "======================================"
echo "      Termux SSH Auto Provisioner"
echo "======================================"
echo -e "${RESET}"


echo "[+] Actualizando paquetes..."

pkg update -y
pkg upgrade -y


echo
echo "[+] Instalando dependencias..."

pkg install -y \
openssh \
net-tools \
procps \
termux-tools


echo
echo "[+] Habilitando acceso al almacenamiento..."

termux-setup-storage || true

sleep 3


echo
echo "[+] Generando claves SSH..."

ssh-keygen -A


echo
echo "======================================"
echo " Configuracion de contraseña SSH"
echo "======================================"

passwd


echo
echo "[+] Reiniciando servidor SSH..."

pkill sshd 2>/dev/null || true

sleep 2

sshd

sleep 3


USER_TERMUX=$(whoami)

PORT=8022


echo
echo "[+] Verificando SSH..."


if pgrep sshd >/dev/null; then

    echo -e "${GREEN}SSH ACTIVO${RESET}"

else

    echo -e "${RED}ERROR: SSH NO INICIADO${RESET}"
    exit 1

fi


echo
echo "[+] Guardando informacion de red..."

ifconfig > ~/network_info.txt


cat > ~/ssh_connection.txt <<EOF
USER=$USER_TERMUX
PORT=$PORT

COMANDO SSH:
ssh -p $PORT $USER_TERMUX@IP_DEL_TELEFONO

NOTA:
Revisa ~/network_info.txt para obtener la IP WiFi.
EOF


echo
echo "======================================"
echo -e "${GREEN} CONFIGURACION COMPLETA ${RESET}"
echo "======================================"

echo

echo "Usuario Termux:"
echo "$USER_TERMUX"

echo

echo "Puerto SSH:"
echo "$PORT"


echo
echo "Comando de conexion:"
echo "ssh -p $PORT $USER_TERMUX@IP_DEL_TELEFONO"


echo
echo "======================================"
echo " INFORMACION DE RED"
echo "======================================"

ifconfig


echo
echo "Archivos generados:"
echo "~/ssh_connection.txt"
echo "~/network_info.txt"


echo
echo "======================================"
echo -e "${GREEN} LISTO ${RESET}"
echo "======================================"
