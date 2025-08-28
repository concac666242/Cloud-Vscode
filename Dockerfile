# TinyCore Linux + Python 3.12
FROM tinycore:current

ENV PY_VER=3.12.6

# Cập nhật và cài gói cần thiết để build Python
RUN tce-load -wi \
    compiletc \
    wget \
    curl \
    ca-certificates \
    openssl-dev \
    zlib_base-dev \
    bzip2-dev \
    sqlite3-dev \
    ncurses-dev \
    xz-dev \
    tk-dev \
    readline-dev \
    gdbm-dev \
    libffi-dev \
    && \
    # Build Python 3.12 từ source
    cd /tmp && \
    wget https://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz && \
    tar xzf Python-${PY_VER}.tgz && \
    cd Python-${PY_VER} && \
    ./configure --enable-optimizations --with-ensurepip=install && \
    make -j$(nproc) && \
    make altinstall && \
    ln -s /usr/local/bin/python3.12 /usr/local/bin/python3 && \
    ln -s /usr/local/bin/pip3.12 /usr/local/bin/pip3 && \
    # Dọn dẹp
    cd / && rm -rf /tmp/Python* 

# Mặc định root, không mật khẩu, lệnh kiểm tra Python
CMD ["python3", "--version"]
