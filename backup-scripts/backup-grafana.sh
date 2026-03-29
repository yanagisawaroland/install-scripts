#!/bin/bash
# Grafana Dashboard 备份
# 每周日执行，保留4份

DATE=$(date +%Y%m%d)
REMOTE="root@10.20.50.75:/www/backup/grafana"
GRAFANA_URL="http://10.20.50.71:32300"
AUTH="admin:Admin1234"

mkdir -p /tmp/grafana-${DATE}

# 获取所有 Dashboard UID
UIDS=$(curl -s -u ${AUTH} ${GRAFANA_URL}/api/search?type=dash-db \
  | python3 -c "import sys,json; [print(d['uid']) for d in json.load(sys.stdin)]")

# 逐个导出
for UID in ${UIDS}; do
  curl -s -u ${AUTH} ${GRAFANA_URL}/api/dashboards/uid/${UID} \
    > /tmp/grafana-${DATE}/${UID}.json
  echo "备份 Dashboard: ${UID}"
done

# 压缩并同步
tar -czf /tmp/grafana-${DATE}.tar.gz -C /tmp grafana-${DATE}/
rsync -av /tmp/grafana-${DATE}.tar.gz ${REMOTE}/
rm -rf /tmp/grafana-${DATE} /tmp/grafana-${DATE}.tar.gz

# 保留最近4份
ssh root@10.20.50.75 "ls -dt /www/backup/grafana/grafana-*.tar.gz | tail -n +5 | xargs rm -f 2>/dev/null"

echo "[$(date)] Grafana Dashboard 备份完成"
