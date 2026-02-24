# jsy-dev

로컬 개발 환경을 빠르게 구성하기 위한 Docker 기반 구성 모음입니다. 루트에는 RabbitMQ, `postgres/`에는 PostgreSQL, `vdev/`에는 Ubuntu 개발 컨테이너 이미지와 실행 스크립트가 있습니다.

## 구성

- `docker-compose.yml`
  - RabbitMQ (`rabbitmq:3-management`)
  - 포트: `5672`(AMQP), `15672`(관리 UI)
  - 기본 계정: `admin / admin`
- `postgres/docker-compose.yml`
  - PostgreSQL (`postgres:17`)
  - 포트: `54321` -> 컨테이너 `5432`
  - 기본 DB/계정: `sample_vgw`, `postgres / 1234`
- `vdev/`
  - `Dockerfile`: Ubuntu 24.04 기반 개발 컨테이너 이미지
  - `docker-compose.yml`: `ghcr.io/vrn-jisooyun/vdev-ubuntu:${TAG_NAME}` 이미지 빌드/실행
  - `make_vdev.sh`: 이미지 빌드/푸시
  - `run_vdev.sh`: 로컬에서 컨테이너 실행(SSH/웹 포트 매핑)

## 요구사항

- Docker, Docker Compose

## 빠른 시작

### 1) RabbitMQ 실행

```bash
docker compose up -d
```

관리 UI: `http://localhost:15672` (계정 `admin / admin`)

### 2) PostgreSQL 실행

```bash
cd postgres
docker compose up -d
```

접속 정보

- Host: `localhost`
- Port: `54321`
- DB: `sample_vgw`
- User/Pass: `postgres / 1234`

### 3) vdev 이미지 빌드/푸시

`vdev/docker-compose.yml`의 `TAG_NAME` 값을 전달해 빌드/푸시합니다.
이미지를 푸시하기 전에 ghcr.io에 docker login이 필요합니다. 

```bash
docker login ghcr.io -u <GITHUB_USERNAME> -p <PERSONAL_ACCESS_TOKEN>
```


```bash
cd vdev
./make_vdev.sh <TAG_NAME>
```

예시

```bash
./make_vdev.sh latest
```

### 4) vdev 컨테이너 실행

```bash
cd vdev
./run_vdev.sh <container_name> <ssh_port> <web_port>
```

예시

```bash
./run_vdev.sh dev1 2222 8080
```

실행 결과 안내

- SSH: `ssh dev@localhost -p <ssh_port>`
- WEB: `http://localhost:<web_port>`
- 컨테이너 이름: `<container_name>_<ssh_port>`
- 볼륨: `vdev_<container> -> /root`

## 보안 주의

기본 계정/비밀번호가 하드코딩되어 있습니다. 로컬 개발용으로만 사용하고 외부 노출은 피하세요.

## 참고

- `vdev/Dockerfile`은 SSH 서버를 활성화하고 `/root`에 bash 설정 파일을 복사합니다.
- `vdev/run_vdev.sh`는 동일 이름 컨테이너가 있으면 제거 후 재생성합니다.
