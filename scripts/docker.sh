#!/bin/bash
set -e

echo "Checking Docker..."

if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed."
else
    echo "Docker is not installed. Installing Docker..."

    sudo apt update
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

    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    echo "Docker installed successfully."
fi

echo "Checking Docker service..."

if ! sudo systemctl is-active --quiet docker; then
    echo "Docker service is not running."
    echo "Starting Docker..."

    sudo systemctl enable --now docker
else
    echo "Docker service is running."
fi

echo "Checking Docker Compose..."

if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose is available."
else
    echo "ERROR: Docker Compose plugin is not available."
    exit 1
fi

if groups "$USER" | grep -q '\bdocker\b'; then
    echo "User '$USER' is already in the Docker group."
else
    echo "Adding user '$USER' to Docker group..."

    sudo usermod -aG docker "$USER"

    echo "User '$USER' added to Docker group."
    echo "A new login session is required for the change to take effect."
fi