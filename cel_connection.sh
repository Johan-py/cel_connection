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
echo "   Termux SSH Auto Setup"
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
echo "[+] Configurando almacenamiento..."

yes | termux-setup-storage || true

sleep 3


echo
echo "[+] Generando host keys SSH..."

ssh-keygen -A


echo
echo "[+] Configurando claves SSH..."

mkdir -p ~/.ssh

chmod 700 ~/.ssh


if [ ! -f ~/.ssh/id_ed25519 ]; then

    ssh-keygen \
    -t ed25519 \
    -N "" \
    -f ~/.ssh/id_ed25519

else

    echo "Clave SSH existente encontrada"

fi


chmod 600 ~/.ssh/id_ed25519


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
echo "[+] Obteniendo informacion de red..."

NETWORK_INFO=$(ifconfig)


echo "$NETWORK_INFO" > /tmp/network.txt


IP=$(echo "$NETWORK_INFO" \
| grep -E "inet " \
| grep -v "127.0.0.1" \
| awk '{print $2}' \
| head -n1)


if [ -z "$IP" ]; then
    IP="BUSCAR_EN_IFCONFIG"
fi



mkdir -p "$DOWNLOAD_DIR"



cat > "$INFO_FILE" <<EOF
========================================
       TERMUX SSH CONNECTION INFO
========================================


USER:
$USER_TERMUX


PORT:
$PORT


SSH COMMAND:

ssh -p $PORT $USER_TERMUX@$IP


IP:

$IP


PUBLIC SSH KEY:

$(cat ~/.ssh/id_ed25519.pub)



NETWORK INFORMATION:

$NETWORK_INFO


PRIVATE KEY LOCATION:

~/.ssh/id_ed25519


PUBLIC KEY LOCATION:

~/.ssh/id_ed25519.pub


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
echo "Archivo generado:"
echo "$INFO_FILE"

echo
echo "SSH:"
echo "ssh -p $PORT $USER_TERMUX@$IP"

echo
echo "======================================"
