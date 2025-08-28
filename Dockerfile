# Kali Linux + Python 3.12 + sudo không mật khẩu
FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive \
    PY_VER=3.12.6

# Gói build và dependencies để build Python từ source
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential wget curl ca-certificates gnupg sudo git \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libffi-dev libncursesw5-dev xz-utils tk-dev uuid-dev liblzma-dev \
  && rm -rf /var/lib/apt/lists/*

# Build & cài Python 3.12 (altinstall để không đụng python hệ thống)
RUN set -eux; \
  cd /tmp; \
  wget -O Python.tgz https://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz; \
  tar xzf Python.tgz; \
  cd Python-${PY_VER}; \
  ./configure --enable-optimizations --with-ensurepip=install; \
  make -j"$(nproc)"; \
  make altinstall; \
  ln -s /usr/local/bin/python3.12 /usr/local/bin/python3; \
  ln -s /usr/local/bin/pip3.12 /usr/local/bin/pip3; \
  cd /; rm -rf /tmp/Python*; \
  /usr/local/bin/python3.12 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Tạo user không mật khẩu và cho sudo NOPASSWD
RUN useradd -m -s /bin/bash kali \
  && usermod -aG sudo kali \
  && passwd -d kali \
  && echo 'kali ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-kali-nopasswd \
  && chmod 0440 /etc/sudoers.d/90-kali-nopasswd

# Thư mục làm việc
WORKDIR /workspace

# Chuyển qua user "kali" (không mật khẩu, sudo không cần password)
USER kali

# Lệnh mặc định: in phiên bản Python
CMD ["python3", "--version"]
