#!/bin/sh

# 默认参数
[ -z "$UUID" ] && UUID="29c3d0c3-33e2-4545-9260-2b0200874e6f"
[ -z "$WS_PATH" ] && WS_PATH="/"
[ -z "$PORT" ] && PORT=8080

echo "🚀 Starting Xray-core..."
echo "   UUID: $UUID"
echo "   Port: $PORT"
echo "   Path: $WS_PATH"

# 生成 Xray 配置文件
cat <<EOF > config.json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$WS_PATH"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# 启动 Xray
exec xray -c config.json
