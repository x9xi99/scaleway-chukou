FROM ghcr.io/sagernet/sing-box:latest

WORKDIR /app

# 复制启动脚本
COPY entrypoint.sh /app/entrypoint.sh

# 赋予执行权限
RUN chmod +x /app/entrypoint.sh

# 设置默认环境变量（Scaleway 会覆盖 PORT）
ENV PORT=8080
ENV UUID=""
ENV WS_PATH="/"

ENTRYPOINT ["/app/entrypoint.sh"]
