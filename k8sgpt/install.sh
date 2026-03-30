#!/bin/bash
# k8sgpt 安装脚本 v0.4.31

export http_proxy=http://10.20.50.4:10809
export https_proxy=http://10.20.50.4:10809

wget -O /usr/local/bin/k8sgpt \
  "https://github.com/k8sgpt-ai/k8sgpt/releases/download/v0.4.31/k8sgpt_Linux_x86_64.tar.gz"

# 或从 node75 恢复
# rsync root@10.20.50.75:/www/bin/k8sgpt /usr/local/bin/
# chmod +x /usr/local/bin/k8sgpt

# 配置连接 Ollama（Mac IP）
k8sgpt auth add \
  --backend localai \
  --baseurl http://10.20.50.18:11434/v1 \
  --model qwen2.5:7b-instruct-q4_K_M \
  --password dummy

k8sgpt auth default -p localai
