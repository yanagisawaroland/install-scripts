#!/bin/bash
# /www 目录备份到 node75
# 每天 23:30 执行，保留2份

DATE=$(date +%Y%m%d)
REMOTE="root@10.20.50.75"
REMOTE_DIR="/www/backup/www"

# 确保目标目录存在
ssh ${REMOTE} "mkdir -p ${REMOTE_DIR}"

# 同步到带日期的目录
rsync -av --delete /www/ ${REMOTE}:${REMOTE_DIR}/www-${DATE}/

if [ $? -eq 0 ]; then
  echo "[$(date)] /www 备份成功 → node75:${REMOTE_DIR}/www-${DATE}/"
  # 只保留最近2份
  ssh ${REMOTE} "ls -dt ${REMOTE_DIR}/www-* | tail -n +3 | xargs -r rm -rf"
  echo "[$(date)] 清理完成，保留最近2份"
else
  echo "[$(date)] /www 备份失败！" >&2
  exit 1
fi
