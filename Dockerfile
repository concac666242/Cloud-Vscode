FROM alpine:latest

ENV PY_VER=3.12.6

RUN apk add --no-cache \
    build-base wget curl ca-certificates \
    openssl-dev bzip2-dev zlib-dev xz-dev \
    sqlite-dev readline-dev tk-dev libffi-dev \
    && cd /tmp \
    && wget https://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz \
    && tar xzf Python-${PY_VER}.tgz \
    && cd Python-${PY_VER} \
    && ./configure --enable-optimizations --with-ensurepip=install \
    && make -j$(nproc) && make altinstall \
    && ln -s /usr/local/bin/python3.12 /usr/local/bin/python3 \
    && ln -s /usr/local/bin/pip3.12 /usr/local/bin/pip3 \
    && cd / && rm -rf /tmp/Python*

CMD ["python3", "--version"]
