#!/data/data/com.termux/files/usr/bin/bash

set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"


echo -e "${GREEN}"
echo "=================================="
echo " Termux SSH Auto Setup"
echo "=================================="
echo -e "${RESET}"


echo "[+] Actualizando paquetes..."
pkg update -y
pkg upgrade -y


echo "[+] Instalando dependencias..."

pkg install -y \
openssh \
termux-tools \
net-tools \
procps


echo
echo "[+] Configurando almacenamiento Android..."
termux-setup-storage || true


echo
echo "[+] Generando claves SSH..."

ssh-keygen -A


echo
echo "=================================="
echo "Configura la contraseña SSH"
echo "=================================="

passwd


echo
echo "[+] Iniciando SSH..."

pkill sshd || true

sshd


sleep 2


USER_TERMUX=$(whoami)

IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')


PORT=8022


echo
echo "=================================="

if ss -tln | grep -q "$PORT"; then

echo -e "${GREEN}SSH FUNCIONANDO${RESET}"

else

echo -e "${RED}ERROR: SSH NO INICIADO${RESET}"
exit 1

fi


echo
echo "DATOS DE CONEXION"
echo "----------------------------------"

echo "USER:"
echo "$USER_TERMUX"

echo

echo "IP:"
echo "$IP"

echo

echo "PORT:"
echo "$PORT"

echo

echo "SSH:"
echo "$USER_TERMUX@$IP"

echo

echo "PASSWORD:"
echo "La contraseña es la que acabas de crear con passwd"

echo
echo "Ejemplo:"
echo "ssh -p $PORT $USER_TERMUX@$IP"

echo

echo "=================================="
echo " Instalacion completada"
echo "=================================="
