#!/usr/bin/env bash
set -euo pipefail

IMAGE="ghcr.io/vrn-jisooyun/vdev-ubuntu:latest"

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <container_name> <ssh_port> <web_port>"
  echo "Example: $0 dev1 2222 8080"
  exit 1
fi

PREFIX="$1"
SSH_PORT="$2"
WEB_PORT="$3"

NAME="${PREFIX}_${SSH_PORT}_${WEB_PORT}"


V_HOME="vdev_home_${NAME}"
V_WS="vdev_ws_${NAME}"

# 볼륨 생성 (없으면)
docker volume create "$V_HOME" >/dev/null 2>&1 || true
docker volume create "$V_WS"   >/dev/null 2>&1 || true

# 이미 존재하는 컨테이너 제거 (원하면 유지 로직으로 바꿀 수 있음)
if docker ps -a --format '{{.Names}}' | grep -qx "$NAME"; then
  echo "[i] Removing existing container $NAME"
  docker rm -f "$NAME"
fi

echo "[+] Starting container $NAME"
docker run -d \
  --name "$NAME" \
  --hostname "$NAME" \
  -p "${SSH_PORT}:22" \
  -p "${WEB_PORT}:8080" \
  -v "${V_HOME}:/home/dev" \
  -v "${V_WS}:/workspace" \
  -w /workspace \
  --restart unless-stopped \
  "$IMAGE"

echo
echo "========================================"
echo "Container: $NAME"
echo "SSH:  ssh dev@localhost -p $SSH_PORT"
echo "WEB:  http://localhost:$WEB_PORT"
echo "Data volumes:"
echo "  $V_HOME -> /home/dev"
echo "  $V_WS   -> /workspace"
echo "========================================"

