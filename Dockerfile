FROM archlinux:latest

ENV DEBIAN_FRONTEND=noninteractive

# Update và cài gói
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm --needed \
    base-devel git sudo python python-pip && \
    pacman -Scc --noconfirm

# Nâng pip ở level root
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Tạo user dev không mật khẩu, sudo NOPASSWD
RUN useradd -m -s /bin/bash dev && \
    passwd -d dev && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-dev && \
    chmod 0440 /etc/sudoers.d/99-dev

# Thư mục làm việc
WORKDIR /workspace

USER dev

CMD ["python", "--version"]
