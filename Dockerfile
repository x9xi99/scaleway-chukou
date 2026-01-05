FROM alpine:latest

WORKDIR /app

# 1. 安装基础工具 (curl 用于下载, ca-certificates 用于 HTTPS)
RUN apk add --no-cache curl ca-certificates

# 2. 安装 Sing-box (使用官方稳定版 v1.9.0)
RUN curl -L -o sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.9.0/sing-box-1.9.0-linux-amd64.tar.gz && \
    tar -xzf sing-box.tar.gz && \
    mv sing-box-*/sing-box /usr/bin/sing-box && \
    chmod +x /usr/bin/sing-box && \
    rm -rf sing-box.tar.gz sing-box-*

# 3. 复制启动脚本
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 4. 设置环境变量
ENV PORT=8080
ENV UUID=""
ENV WS_PATH="/"

# 5. 启动
CMD ["/app/entrypoint.sh"]
