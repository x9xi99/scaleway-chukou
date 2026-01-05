FROM alpine:latest

WORKDIR /app

# 1. 安装基础工具
RUN apk add --no-cache curl ca-certificates unzip

# 2. 安装 Xray-core (使用官方最新版)
# Xray 不会像 Sing-box 那样尝试操作底层网络，非常适合 Serverless
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip xray.zip && \
    mv xray /usr/bin/xray && \
    chmod +x /usr/bin/xray && \
    rm -rf xray.zip geoip.dat geosite.dat

# 3. 复制启动脚本
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 4. 环境变量
ENV PORT=8080 UUID="" WS_PATH="/"

# 5. 启动
CMD ["/app/entrypoint.sh"]
