#!/bin/bash
# Sealed Secrets 安装脚本
# 控制器版本：0.36.1，Helm Chart：2.18.4

# 前提：镜像已推送到 Harbor
# skopeo copy \
#   --dest-tls-verify=false --dest-creds admin:Harbor12345 \
#   docker://docker.io/bitnami/sealed-secrets-controller:0.36.1 \
#   docker://harbor.devops.local:7581/devops/sealed-secrets-controller:0.36.1

helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update

helm install sealed-secrets sealed-secrets/sealed-secrets \
  --namespace kube-system \
  --version 2.18.4 \
  --set fullnameOverride=sealed-secrets-controller \
  --set image.registry=harbor.devops.local:7581 \
  --set image.repository=devops/sealed-secrets-controller \
  --set image.tag=0.36.1 \
  --set image.pullPolicy=IfNotPresent

# 安装 kubeseal 客户端
curl -sL https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.36.1/kubeseal-0.36.1-linux-amd64.tar.gz \
  -o /tmp/kubeseal.tar.gz
tar -xzf /tmp/kubeseal.tar.gz -C /tmp/
mv /tmp/kubeseal /usr/local/bin/kubeseal
chmod +x /usr/local/bin/kubeseal

# 验证
kubeseal --version
