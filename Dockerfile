FROM ubuntu:24.04

# Cập nhật và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    curl wget git sudo nano apt-transport-https python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Tạo user non-root để chạy code-server
RUN useradd -m coder && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Cài đặt code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Thư mục làm việc mặc định
WORKDIR /home/coder/project

# Cấu hình code-server (không cần password)
RUN mkdir -p /home/coder/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080\n\
auth: none\n\
cert: false" > /home/coder/.config/code-server/config.yaml && \
    chown -R coder:coder /home/coder

# Mở cổng 8080
EXPOSE 8080

# Chạy code-server
USER coder
CMD ["code-server", "--host", "0.0.0.0", "--port", "8080", "/home/coder/project"]
