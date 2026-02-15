#!/bin/bash
set -e

if [[ "$(uname)" != "Darwin" ]]; then
    shopt -s expand_aliases
    alias docker='sudo docker'
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/../.."
CORE_DIR="$SCRIPT_DIR/.."


if [ -z "$1" ]; then
    usage
fi

SERVICE_NAME="$1"

case "$SERVICE_NAME" in
    frontend)
        SERVICE_DIR="devoops-frontend"
        ;;
    gateway|user|accommodation|notification|rating|reservation|search)
        SERVICE_DIR="devoops-$SERVICE_NAME-service"
        ;;
    *)
        echo "Error: Unknown service '$SERVICE_NAME'"
        usage
        ;;
esac

if [ ! -d "$ROOT_DIR/$SERVICE_DIR" ]; then
    echo "Error: Service directory '$SERVICE_DIR' not found"
    exit 1
fi

if [ "$SERVICE_NAME" != "frontend" ]; then
    echo "Building $SERVICE_NAME with Gradle..."
    cd "$ROOT_DIR/$SERVICE_DIR"
    chmod +x gradlew
    ./gradlew clean build -x test
    echo "Gradle build completed for $SERVICE_NAME"
else
    echo "Skipping Gradle build for frontend (Angular project)"
fi

echo ""
echo "Starting Docker container for $SERVICE_NAME..."
cd "$CORE_DIR"

docker compose up -d --build "$SERVICE_NAME-service"

echo ""
echo "Done! $SERVICE_NAME is now running."
