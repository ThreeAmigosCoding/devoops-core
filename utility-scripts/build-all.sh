#!/bin/bash
set -e

services="user-service accommodation-service notification-service rating-service reservation-service search-service "

cd ../../
for service in $services; do
  echo "Building $service ..."
  cd "devoops-$service" && chmod +x gradlew && ./gradlew clean build
  echo "Done building $service"
  cd ..
done