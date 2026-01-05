#!/bin/sh

# 如果没有设置 UUID，自动生成一个
if [ -z "$UUID" ]; then
  UUID="29c3d0c3-33e2-4545-9260-2b0200874e6f"
  echo "No UUID provided, using default: $UUID"
fi

# 如果没有设置 WS_PATH，默认为 /
if [ -z "$WS_PATH" ]; then
  WS_PATH="/"
fi

# 生成 config.json
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

echo "Starting Sing-box on port $PORT with UUID $UUID..."
exec sing-box run -c config.json
