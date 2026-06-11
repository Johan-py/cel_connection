#!/data/data/com.termux/files/usr/bin/bash

set -e


GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"


DOWNLOAD_DIR="/data/data/com.termux/files/home/storage/downloads"
INFO_FILE="$DOWNLOAD_DIR/termux_ssh_info.txt"


clear


echo -e "${GREEN}"
echo "======================================"
echo "      Termux SSH Auto Setup"
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
echo "[+] Activando almacenamiento..."

yes | termux-setup-storage || true

sleep 3


echo
echo "[+] Generando host keys SSH..."

ssh-keygen -A


echo
echo "======================================"
echo " Crea la contraseña SSH"
echo "======================================"

passwd


echo
echo "[+] Reiniciando SSH..."

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
echo "[+] Guardando informacion..."


NETWORK_INFO=$(ifconfig)


echo "$NETWORK_INFO" > "$DOWNLOAD_DIR/network.txt"



mkdir -p "$DOWNLOAD_DIR"



cat > "$INFO_FILE" <<EOF
========================================
       TERMUX SSH CONNECTION INFO
========================================


USER:

$USER_TERMUX


PORT:

$PORT


CONNECTION:

ssh -p $PORT $USER_TERMUX@IP_DEL_TELEFONO



NETWORK INFORMATION:

$NETWORK_INFO



STATUS:

SSH RUNNING


========================================
EOF



echo
echo "======================================"
echo -e "${GREEN} CONFIGURACION COMPLETA ${RESET}"
echo "======================================"


echo

echo "Usuario:"
echo "$USER_TERMUX"


echo

echo "Puerto:"
echo "$PORT"


echo

echo "Conexion:"
echo "ssh -p $PORT $USER_TERMUX@IP_DEL_TELEFONO"


echo

echo "Archivo generado:"
echo "$INFO_FILE"


echo
echo "======================================"
