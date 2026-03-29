#!/bin/bash
# MySQL 数据备份
# 每天23:05执行，保留7天

DATE=$(date +%Y%m%d)
REMOTE="root@10.20.50.75:/www/backup/mysql"
NS="mysql"

# 获取 MySQL Pod 名称
MYSQL_POD=$(kubectl get pod -n ${NS} -l app.kubernetes.io/component=pxc \
  -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "${MYSQL_POD}" ]; then
  echo "[$(date)] MySQL Pod 未找到，跳过备份"
  exit 0
fi

echo "[$(date)] 使用 Pod：${MYSQL_POD}"

# 执行 mysqldump
kubectl exec -n ${NS} ${MYSQL_POD} -- \
  mysqldump -u root -p'Root@Percona2024!' \
  --all-databases \
  --single-transaction \
  --routines \
  --triggers \
  > /tmp/mysql-${DATE}.sql

if [ $? -eq 0 ]; then
  gzip /tmp/mysql-${DATE}.sql
  rsync -av /tmp/mysql-${DATE}.sql.gz ${REMOTE}/
  rm -f /tmp/mysql-${DATE}.sql.gz
  # 清理7天前的备份
  ssh root@10.20.50.75 "find /www/backup/mysql/ -name 'mysql-*.sql.gz' -mtime +7 -delete"
  echo "[$(date)] MySQL 备份完成"
else
  echo "[$(date)] MySQL 备份失败！" >&2
  rm -f /tmp/mysql-${DATE}.sql
  exit 1
fi
