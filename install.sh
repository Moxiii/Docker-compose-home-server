#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=================================="
echo " Server bootstrap"
echo "=================================="

echo "[1/5] Updating system..."
"$SCRIPT_DIR/scripts/update.sh"

echo "[2/5] Installing Docker..."
"$SCRIPT_DIR/scripts/docker.sh"

echo "[3/5] Creating Docker networks..."
"$SCRIPT_DIR/scripts/network.sh"

echo "[4/5] Installing UFW..."
"$SCRIPT_DIR/scripts/ufw.sh"

echo "[5/5] Installing WireGuard..."
"$SCRIPT_DIR/scripts/wireguard.sh"

echo
echo "=================================="
echo " Bootstrap completed successfully"
echo "=================================="