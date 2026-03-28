#!/bin/bash
# Jaeger + OpenTelemetry Collector 安装脚本

kubectl create namespace observability

# 安装 Jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install jaeger jaegertracing/jaeger \
  --namespace observability \
  --set allInOne.enabled=true \
  --set collector.service.otlp.grpc.name=otlp-grpc \
  --set query.service.type=NodePort \
  --set query.service.nodePort=32686

# 安装 OTel Collector
# 参考 /www/devops/ 下的 otel-collector 配置

# 验证
kubectl get pods -n observability
