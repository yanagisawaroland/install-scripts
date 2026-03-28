#!/bin/bash
# kube-prometheus-stack 安装脚本
# 包含：Prometheus + Grafana + AlertManager + Node Exporter + kube-state-metrics

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set grafana.adminPassword=Admin1234 \
  --set prometheus.service.nodePort=32301 \
  --set prometheus.service.type=NodePort \
  --set grafana.service.nodePort=32300 \
  --set grafana.service.type=NodePort \
  --set alertmanager.service.nodePort=32302 \
  --set alertmanager.service.type=NodePort

# 验证
kubectl get pods -n monitoring
