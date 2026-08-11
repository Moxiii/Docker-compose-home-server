#!/bin/bash

set -e

if [ ! -f .env ]; then
    echo "Génération de la configuration Homarr..."

    SECRET_KEY=$(openssl rand -hex 32)

    cat > .env <<EOF
SECRET_ENCRYPTION_KEY=$SECRET_KEY
EOF

    chmod 600 .env

    echo ".env créé."
else
    echo ".env existe déjà, conservation de la configuration."
fi

docker compose up -d