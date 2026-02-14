#!/bin/bash

# 启动ServerStatus服务
/ServerStatus/server/sergate --config=/ServerStatus/server/config.json --web-dir=/usr/share/nginx/html &

# 启动文件同步循环
while true; do
  if [ -f "/usr/share/nginx/html/json/stats.json" ]; then
    cp -f "/usr/share/nginx/html/json/stats.json" "/ServerStatus/json_build/stats.json" 2>/dev/null || true
  fi
  sleep 5
done