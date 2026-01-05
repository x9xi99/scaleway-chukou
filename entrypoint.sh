#!/bin/sh

# 默认参数
[ -z "$UUID" ] && UUID="29c3d0c3-33e2-4545-9260-2b0200874e6f"
[ -z "$WS_PATH" ] && WS_PATH="/"
[ -z "$PORT" ] && PORT=8080

echo "🚀 Starting Pure Sing-box..."
echo "   Port: $PORT"
echo "   UUID: $UUID"
echo "   Path: $WS_PATH"

# 生成配置文件
cat <<EOF > config.json
{
  "log": {
    "level": "info",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-in",
      "listen": "0.0.0.0",
      "listen_port": $PORT,
      "users": [
        {
          "uuid": "$UUID",
          "name": "scaleway-user"
        }
      ],
      "transport": {
        "type": "ws",
        "path": "$WS_PATH",
        "early_data_header_name": "Sec-WebSocket-Protocol"
      }
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ]
}
EOF

# 使用 exec 让 Sing-box 成为主进程 (PID 1)
# 这样容器停止时，Sing-box 能收到信号并优雅退出
exec sing-box run -c config.json
