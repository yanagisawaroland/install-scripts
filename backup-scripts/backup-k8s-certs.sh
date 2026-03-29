#!/bin/bash
# K8s 证书和配置备份
# 每周日执行，保留4份

DATE=$(date +%Y%m%d)
REMOTE="root@10.20.50.75:/www/backup/k8s-certs"

# 备份证书
rsync -av /etc/kubernetes/pki/ ${REMOTE}/pki-${DATE}/
rsync -av /etc/kubernetes/admin.conf ${REMOTE}/admin-${DATE}.conf
rsync -av /etc/kubernetes/manifests/ ${REMOTE}/manifests-${DATE}/

# 保留最近4份
ssh root@10.20.50.75 "ls -dt /www/backup/k8s-certs/pki-* | tail -n +5 | xargs rm -rf 2>/dev/null"

echo "[$(date)] K8s 证书备份完成"
