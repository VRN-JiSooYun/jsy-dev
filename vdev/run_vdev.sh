#!/usr/bin/env bash
set -euo pipefail

IMAGE="dev-ubuntu:24.04"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <container_name> [--] [extra docker run args...]"
  echo "Example: $0 dev-jisoo"
  exit 1
fi

NAME="$1"
shift || true

VOLUME="devdata_${NAME}"
WORKDIR="/workspace"

# 볼륨 없으면 생성
if ! docker volume inspect "$VOLUME" >/dev/null 2>&1; then
  docker volume create "$VOLUME" >/dev/null
  echo "[+] Created volume: $VOLUME"
fi

# 기존 컨테이너 존재 여부 확인
if docker ps -a --format '{{.Names}}' | grep -qx "$NAME"; then
  if docker ps --format '{{.Names}}' | grep -qx "$NAME"; then
    echo "[i] Container '$NAME' is already running."
  else
    echo "[i] Starting existing container '$NAME'..."
    docker start "$NAME" >/dev/null
  fi
else
  echo "[+] Creating and starting container '$NAME'..."
  docker run -d \
    --name "$NAME" \
    --hostname "$NAME" \
    -v "${VOLUME}:${WORKDIR}" \
    -w "${WORKDIR}" \
    -it \
    --restart unless-stopped \
    "$IMAGE" \
    "$@"
fi

echo
echo "Attach shell:"
echo "  docker exec -it \"$NAME\" bash"
echo
echo "Data volume:"
echo "  $VOLUME -> $WORKDIR"

