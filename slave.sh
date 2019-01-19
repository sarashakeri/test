sudo apt update
sudo apt install -y apt-transport-https curl ca-certificates curl software-properties-common

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

# Kubernetes apt
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update
# Make sure kubeadm, kubectl and kubelet versions match
apt install -y kubelet=1.12.2-00 kubeadm kubectl

# kubeadm join ...
# dmp cluster:
kubeadm join 172.21.47.201:6443 --token sunix3.lggbkp8o0okjl5gu --discovery-token-ca-cert-hash sha256:c5c7d2baf5ce626b49937789d76a79ea461dac65832ed1446b195e765a627db0

