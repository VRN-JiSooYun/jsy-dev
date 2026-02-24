#!/bin/bash

# Usage: ./make_vdev.sh <TAG_NAME>
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <TAG_NAME>"
    exit 1
fi

TAG_NAME="$1"

# Read image name from docker-compose.yml
IMAGE_NAME=$(grep 'image:' docker-compose.yml | head -1 | awk '{print $2}' | sed "s/\${TAG_NAME}/$TAG_NAME/g")

if [ -z "$IMAGE_NAME" ]; then
    echo "Could not find image name in docker-compose.yml"
    exit 1
fi

echo "Building Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f Dockerfile .

echo "Pushing Docker image: $IMAGE_NAME"
docker push "$IMAGE_NAME"

echo "Done."