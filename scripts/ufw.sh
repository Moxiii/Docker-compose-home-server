#!/bin/bash

set -e

echo "=================================="
echo " UFW configuration"
echo "=================================="

if ! command -v ufw &> /dev/null; then
    echo "UFW is not installed. Installing UFW..."
    sudo apt update
    sudo apt install -y ufw
else
    echo "UFW is already installed."
fi

echo "[1/4] Setting default policies..."

sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "[2/4] Allowing SSH..."

sudo ufw allow 22/tcp

echo "[3/4] Allowing web traffic..."

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

echo "[4/4] Enabling UFW..."

sudo ufw --force enable

echo
echo "=================================="
echo " UFW status"
echo "=================================="

sudo ufw status verbose