#!/bin/bash

set -e

echo "=================================="
echo " Server bootstrap"
echo "=================================="

echo "[1/6] Updating system..."

sudo apt update
sudo apt upgrade -y

echo "[2/6] Checking Docker..."

if command -v docker &> /dev/null
then
    echo "Docker is already installed."
else
    echo "Docker is not installed. Installing Docker..."
    sudo apt install -y ca-certificates curl

    sudo install -m 0755 -d /etc/apt/keyrings

    sudo curl -fsSL \
        https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

     sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Docker installed successfully."
fi

echo "[3/6] Starting Docker..."

sudo systemctl enable --now docker

echo "[4/6] Creating Docker networks..."

create_network() {
    local network="$1"

    if sudo docker network inspect "$network" >/dev/null 2>&1; then
        echo "Network '$network' already exists."
    else
        echo "Creating network '$network'..."
        sudo docker network create "$network"
    fi
}

create_network proxy
create_network monitoring-internal

echo "[5/6] Adding user to Docker group..."
sudo usermod -aG docker $USER
echo "User '$USER' added to Docker group. You may need to log out and log back in for this change to take effect."
echo "[6/6] Installing Wireguard..."
if command -v wg >/dev/null 2>&1; then
    echo "WireGuard is already installed."
else
    echo "Installing WireGuard..."
    sudo apt install -y wireguard
fi


echo "=================================="
echo " Bootstrap completed successfully"
echo "=================================="
