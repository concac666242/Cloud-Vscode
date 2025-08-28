# Arch Linux + Python 3.12 + sudo không mật khẩu (VS Code)
FROM archlinux:latest

# Tắt hỏi khi cài gói
ENV DEBIAN_FRONTEND=noninteractive

# Update & cài gói cần thiết (bao gồm openssl, libffi để pip hoạt động)
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm --needed \
    base-devel git sudo python python-pip \
    openssl zlib libffi && \
    pacman -Scc --noconfirm

# Tạo user dev có sudo không mật khẩu
RUN useradd -m -s /bin/bash dev && \
    passwd -d dev && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-dev && \
    chmod 0440 /etc/sudoers.d/99-dev

# Làm việc trong thư mục /workspace
WORKDIR /workspace

# Chuyển sang user dev
USER dev

# Fix pip lỗi bằng cách nâng cấp
RUN python -m ensurepip --upgrade && \
    pip install --no-cache-dir --upgrade pip setuptools wheel

# Lệnh mặc định
CMD ["python", "--version"]
