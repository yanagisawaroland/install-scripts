#!/bin/bash
# etcd 快照备份
# 每天凌晨2点执行，保留7天

DATE=$(date +%Y%m%d)
BACKUP_DIR="/tmp/backup"
REMOTE="root@10.20.50.75:/www/backup/etcd"

mkdir -p ${BACKUP_DIR}

# 生成快照
ETCDCTL_API=3 etcdctl snapshot save ${BACKUP_DIR}/etcd-${DATE}.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

if [ $? -eq 0 ]; then
  echo "[$(date)] etcd 备份成功：etcd-${DATE}.db"
  # 同步到 node75
  rsync -av ${BACKUP_DIR}/etcd-${DATE}.db ${REMOTE}/
  # 清理本地临时文件
  rm -f ${BACKUP_DIR}/etcd-${DATE}.db
  # 清理 node75 上7天前的备份
  ssh root@10.20.50.75 "find /www/backup/etcd/ -name 'etcd-*.db' -mtime +7 -delete"
  echo "[$(date)] etcd 备份同步完成"
else
  echo "[$(date)] etcd 备份失败！" >&2
  exit 1
fi
