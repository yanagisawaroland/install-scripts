#!/bin/bash
# Sealed Secrets 控制器私钥备份
# 每周日执行，永久保留

DATE=$(date +%Y%m%d)
REMOTE="root@10.20.50.75:/www/backup/sealed-secrets"

# 导出 Sealed Secrets 密钥
kubectl get secret -n kube-system \
  -l sealedsecrets.bitnami.com/sealed-secrets-key \
  -o yaml > /tmp/sealed-secrets-key-${DATE}.yaml

if [ $? -eq 0 ]; then
  rsync -av /tmp/sealed-secrets-key-${DATE}.yaml ${REMOTE}/
  rm -f /tmp/sealed-secrets-key-${DATE}.yaml
  echo "[$(date)] Sealed Secrets 私钥备份完成"
else
  echo "[$(date)] Sealed Secrets 备份失败！" >&2
  exit 1
fi
