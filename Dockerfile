FROM python:3.12-slim

RUN apt-get update && apt-get install -y curl wget git sudo nano apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Cài code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN mkdir -p /root/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8080\nauth: none\ncert: false" > /root/.config/code-server/config.yaml

WORKDIR /root/project
EXPOSE 8080
CMD ["code-server", "--host", "0.0.0.0", "--port", "8080", "/root/project"]
