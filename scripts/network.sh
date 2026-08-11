#!/bin/bash

set -e

create_network() {
    local network="$1"

    if docker network inspect "$network" >/dev/null 2>&1; then
        echo "Network '$network' already exists."
    else
        echo "Creating network '$network'..."
        docker network create --driver bridge "$network"
    fi
}

create_network proxy
create_network monitoring-internal