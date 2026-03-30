#!/bin/bash
# GitLab 安装脚本
# 版本：gitlab-ce:16.9.0-ce.0
# 内存：5G

mkdir -p /data/gitlab/config /data/gitlab/logs /data/gitlab/data

docker run -d \
  --name gitlab \
  --restart always \
  --hostname gitlab.devops.local \
  --memory 5g \
  --memory-swap 6g \
  -p 7591:8181 \
  -e GITLAB_OMNIBUS_CONFIG="external_url 'http://10.20.50.75:7591'; nginx['listen_port'] = 8181;" \
  -v /data/gitlab/config:/etc/gitlab \
  -v /data/gitlab/logs:/var/log/gitlab \
  -v /data/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:16.9.0-ce.0

echo "等待 GitLab 启动约 2-3 分钟..."
