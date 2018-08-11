#!/bin/bash

set -e

# This script sets up Etcd, Flannel and Kubernetes Master
# for a single master and 3 minions configuration.

echo "Starting kubelet..."
rc-update add kubelet
rc-service kubelet start

echo "Running kubeadm join to configure kubernetes..."
echo "cluster_token is ${KUBE_TOKEN}"
echo kubeadm join --ignore-preflight-errors=all --token "${KUBE_TOKEN}" ${MASTER_LB_IP}:6443 --discovery-token-unsafe-skip-ca-verification
sleep 120

# I think the next step needst to run kubelet, but cannot as it is in kypercube not /usr/bin
kubeadm join --ignore-preflight-errors=all --token "${KUBE_TOKEN}" ${MASTER_LB_IP}:6443 --discovery-token-unsafe-skip-ca-verification

#copy kubeconfig for root's usage
mkdir -p /root/.kube
cp /etc/kubernetes/kubelet.conf /root/.kube/config

rc-service kubelet restart


