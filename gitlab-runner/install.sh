#!/bin/bash
# GitLab Runner 安装脚本（K8s executor）

helm repo add gitlab https://charts.gitlab.io
helm repo update

# 注册 Runner 后获取 Token，填入下方
RUNNER_TOKEN="<从 GitLab Admin → CI/CD → Runners 获取>"

helm install gitlab-runner gitlab/gitlab-runner \
  --namespace gitlab-runner \
  --create-namespace \
  --set gitlabUrl=http://10.20.50.75:7591 \
  --set runnerToken=${RUNNER_TOKEN} \
  --set rbac.create=true \
  --set runners.tags="k8s" \
  --set runners.privileged=false

# 验证
kubectl get pods -n gitlab-runner
