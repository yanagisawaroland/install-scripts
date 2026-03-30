#!/bin/bash
# k8sgpt 安装脚本 v0.4.31
# 依赖：Mac 上运行 Ollama，模型 deepseek-coder-v2:16b-lite-instruct-q4_K_M

# 从 node75 恢复二进制
rsync root@10.20.50.75:/www/bin/k8sgpt /usr/local/bin/
chmod +x /usr/local/bin/k8sgpt

# 配置连接 Mac Ollama（注意 Mac IP 可能变化）
k8sgpt auth add \
  --backend localai \
  --baseurl http://10.20.50.18:11434/v1 \
  --model deepseek-coder-v2:16b-lite-instruct-q4_K_M \
  --password dummy

k8sgpt auth default -p localai

echo "k8sgpt 安装完成"
echo "使用方式："
echo "  k8sgpt analyze --explain --namespace production"
echo "  k8sgpt analyze --explain --namespace staging"
echo "  k8sgpt analyze --explain --filter Pod"
