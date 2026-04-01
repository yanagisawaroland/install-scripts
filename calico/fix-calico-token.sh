#!/bin/bash
# Calico CNI Token 根治脚本
# 适用于 K8s 1.24+ 集群
# 解决：FailedCreatePodSandBox / connection is unauthorized
#
# 背景：Calico 有两套 token：
# 1. calico-node daemon token（Pod serviceAccount）
# 2. CNI plugin token（/etc/cni/net.d/calico-kubeconfig）
# 两套都必须修，缺一不可

set -e

echo "=== 步骤1：创建长期 ServiceAccount Secret token ==="
kubectl apply -f - << YAML
apiVersion: v1
kind: Secret
metadata:
  name: calico-node-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: calico-node
type: kubernetes.io/service-account-token
YAML

sleep 3

echo "=== 步骤2：patch calico-node DaemonSet ==="
kubectl patch daemonset calico-node -n kube-system --type=json -p='[
  {"op":"add","path":"/spec/template/spec/volumes/-",
   "value":{"name":"calico-node-token","secret":{"secretName":"calico-node-token"}}},
  {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts/-",
   "value":{"name":"calico-node-token",
    "mountPath":"/var/run/secrets/kubernetes.io/serviceaccount","readOnly":true}}
]'

kubectl rollout status daemonset calico-node -n kube-system

echo "=== 步骤3：获取长期 token ==="
LONG_TOKEN=$(kubectl get secret calico-node-token -n kube-system \
  -o jsonpath='{.data.token}' | base64 -d)
echo "Token 长度: ${#LONG_TOKEN}"
echo ""
echo "=== 步骤4：在每个 worker 节点上执行 ==="
echo "sed -i 's|token:.*|token: ${LONG_TOKEN}|' /etc/cni/net.d/calico-kubeconfig"
echo ""
echo "验证（无 exp 字段 = 永久 token）："
echo "cat /etc/cni/net.d/calico-kubeconfig | grep token | awk '{print \$2}' | cut -d'.' -f2 | base64 -d 2>/dev/null | python3 -m json.tool | grep -E 'exp|iss'"
