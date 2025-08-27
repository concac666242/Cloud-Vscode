FROM ubuntu:23.04

# Thiết lập môi trường tránh hỏi timezone khi cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt Python 3.12 + các công cụ cần thiết
RUN apt-get update && apt-get install -y \
    python3 python3-pip curl wget git sudo nano apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt code-server (VS Code Web)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Cấu hình code-server (không cần password)
RUN mkdir -p /root/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080\n\
auth: none\n\
cert: false" > /root/.config/code-server/config.yaml

# Thư mục làm việc mặc định
WORKDIR /root/project

# Mở cổng 8080
EXPOSE 8080

# Chạy code-server khi container khởi động
CMD ["code-server", "--host", "0.0.0.0", "--port", "8080", "/root/project"]
