#!/bin/bash
set -e 

echo "Installing Wireguard..."
if command -v wg >/dev/null 2>&1; then
    echo "WireGuard is already installed."
else
    echo "Installing WireGuard..."
    sudo apt install -y wireguard
fi
