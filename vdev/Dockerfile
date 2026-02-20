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
      openssh-server sudo \
# Python 기본
      python3 python3-pip python3-venv \
      build-essential \
      python3-dev \
      libssl-dev \
      libffi-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      libncursesw5-dev \
      tk-dev \
      libxml2-dev \
      libxmlsec1-dev \
      xz-utils \
      locales && \
    rm -rf /var/lib/apt/lists/*

# SSH Config
RUN echo "root:1234qwer" | chpasswd

RUN mkdir /var/run/sshd
RUN sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?UsePAM .*/UsePAM yes/' /etc/ssh/sshd_config

# 로케일(선택)
RUN locale-gen en_US.UTF-8 || true
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# 작업 디렉토리(컨테이너에서 여기 아래로 작업 권장)
WORKDIR /workspace

# bashrc 커스터마이징(아래 custom_bashrc 파일을 넣을 예정)
COPY custom_bashrc /etc/profile.d/custom_bashrc.sh

# 컨테이너가 꺼지지 않도록 기본 커맨드
CMD ["bash", "-lc", "mkdir -p /run/sshd; ssh-keygen -A; /usr/sbin/sshd; exec sleep infinity"]
