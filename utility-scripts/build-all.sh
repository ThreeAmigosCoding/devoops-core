#!/bin/bash
set -e

services="user-service accommodation-service notification-service rating-service reservation-service gateway-service"

cd ../../
for service in $services; do
  echo "Building $service ..."
  cd "devoops-$service" && chmod +x gradlew && ./gradlew clean build -x test
  echo "Done building $service"
  cd ..
done

echo "Building images..."
cd devoops-core
docker compose up -d --build
echo "Done building images"