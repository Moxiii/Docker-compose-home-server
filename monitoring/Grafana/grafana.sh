#!/bin/bash

set -e

if [ ! -f .env ]; then
    echo "Génération de la configuration Code server..."

    PASSWORD=$(openssl rand -hex 32)

    cat > .env <<EOF
CODE_SERVER_PASSWORD=$PASSWORD
EOF

    chmod 600 .env

    echo ".env créé."
else
    echo ".env existe déjà, conservation de la configuration."
fi

docker compose up -d