#!/bin/sh

# 默认参数
[ -z "$UUID" ] && UUID="29c3d0c3-33e2-4545-9260-2b0200874e6f"
[ -z "$WS_PATH" ] && WS_PATH="/"
[ -z "$PORT" ] && PORT=8080

echo "🚀 Starting Sing-box (Serverless Mode)..."
echo "   UUID: $UUID"
echo "   Port: $PORT"

# 生成配置文件
# 关键修复：禁用 auto_detect_interface 和 auto_route
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
  ],
  "route": {
    "auto_detect_interface": false,
    "auto_route": false
  }
}
EOF

# 启动
exec sing-box run -c config.json
