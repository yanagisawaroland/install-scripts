#!/bin/bash
# ArgoCD 安装脚本
# 版本：v2.10.x

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 等待启动
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# 改为 NodePort
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort","ports":[{"port":443,"nodePort":30443}]}}'

# 获取初始密码
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# 修改密码
# argocd login 10.20.50.71:30443 --username admin --insecure
# argocd account update-password
