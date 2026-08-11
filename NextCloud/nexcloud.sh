#!/bin/bash
set -e

if [ ! -f .env ]; then
    echo "Génération de la configuration Nextcloud..."

    PASSWORD=$(openssl rand -hex 32)
    USERNAME=$(openssl rand -hex 16)

    cat > .env <<EOF
NEXTCLOUD_POSTGRES_USERNAME=$USERNAME
NEXTCLOUD_POSTGRES_PASSWORD=$PASSWORD
EOF

    chmod 600 .env

    echo ".env créé."
else
    echo ".env existe déjà, conservation de la configuration."
fi

docker compose up -d