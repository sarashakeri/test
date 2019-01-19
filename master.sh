#!/bin/bash
# Initialisation of the master node
# Make sure this is executed as root

swapoff -a

apt update
apt install curl apt-transport-https ca-certificates software-properties-common

# Kubernetes apt 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

# Make sure kubeadm, kubectl and kubelet versions match
apt install kubelet=1.12.2-00 kubeadm kubectl 
# Node not installed yet

# kubeadm init --pod-network-cidr=192.168.0.0/16 > init.log
# KLM node 1:
# Make sure the --node-ip is set if required (see logs)
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address 172.21.47.201 > init.log
cat init.log | tail -16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# Calico
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml 

# Run a kubectl proxy to connect to the kubectl (API):
kubectl proxy --port=8080 --address='10.0.0.3' --accept-hosts='.*' 
