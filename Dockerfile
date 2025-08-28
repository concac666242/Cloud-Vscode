# Arch Linux + Python 3.12 + sudo không mật khẩu (cho VS Code)
FROM archlinux:latest

ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật hệ thống và cài các gói cơ bản + Python 3.12 + sudo
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm --needed \
    base-devel git sudo python python-pip \
    && pacman -Scc --noconfirm

# Tạo user "dev" không mật khẩu, có sudo NOPASSWD
RUN useradd -m -s /bin/bash dev && \
    passwd -d dev && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-dev && \
    chmod 0440 /etc/sudoers.d/99-dev

# Thư mục làm việc
WORKDIR /workspace

# Chuyển sang user dev (không pass)
USER dev

# Cài pip và tool Python cơ bản
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Lệnh mặc định
CMD ["python", "--version"]
