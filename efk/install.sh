#!/bin/bash
# EFK 日志系统安装脚本
# Elasticsearch + Kibana + Fluent Bit

# 安装 Elasticsearch
helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch \
  --namespace logging --create-namespace \
  --set replicas=1 \
  --set minimumMasterNodes=1 \
  --set resources.requests.memory=512Mi \
  --set service.type=NodePort \
  --set service.nodePort=32304

# 安装 Kibana
helm install kibana elastic/kibana \
  --namespace logging \
  --set service.type=NodePort \
  --set service.nodePort=32303

# 安装 Fluent Bit
helm repo add fluent https://fluent.github.io/helm-charts
helm install fluent-bit fluent/fluent-bit \
  --namespace logging \
  --set backend.type=es \
  --set backend.es.host=elasticsearch-master.logging.svc

# 验证
kubectl get pods -n logging
