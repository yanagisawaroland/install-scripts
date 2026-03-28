#!/bin/bash
# metrics-server 安装脚本

# 下载 yaml
curl -sL https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml \
  -o metrics-server.yaml

# 添加 --kubelet-insecure-tls 参数（自签名证书环境必须）
sed -i '/- args:/a\        - --kubelet-insecure-tls' metrics-server.yaml

# 替换镜像为 Harbor
sed -i 's|registry.k8s.io/metrics-server/metrics-server|harbor.devops.local:7581/devops/metrics-server|g' \
  metrics-server.yaml

kubectl apply -f metrics-server.yaml

# 验证
kubectl get deployment metrics-server -n kube-system
kubectl top nodes
