# Dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-lc"]

# 기본 개발/디버깅 툴 + 편의 패키지
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      vim \
      net-tools \
      tcpdump \
      curl \
      ca-certificates \
      git \
      less \
      iputils-ping \
      dnsutils \
      procps \
      lsof \
      tzdata \
      locales && \
    rm -rf /var/lib/apt/lists/*

# 로케일(선택)
RUN locale-gen en_US.UTF-8 || true
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# 작업 디렉토리(컨테이너에서 여기 아래로 작업 권장)
WORKDIR /workspace

# bashrc 커스터마이징(아래 custom_bashrc 파일을 넣을 예정)
COPY custom_bashrc /etc/profile.d/custom_bashrc.sh

# 컨테이너가 꺼지지 않도록 기본 커맨드
CMD ["bash", "-lc", "sleep infinity"]

