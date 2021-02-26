#!/bin/bash

if [ $(whoami) != root ]; then
  echo please run this script as root or using sudo
  exit
fi

colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

printf "${GREEN}Starting installation..."

#######################################
#          INSTALLING DOCKER          #
#######################################
printf "\n${YELLOW}Installing docker... ${NC}\n"

#update system
apt-get update

# install needed software
apt-get update && apt-get install -y \
  apt-transport-https ca-certificates curl software-properties-common gnupg2

# download docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -

# add docker repository for debian
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

apt-cache policy docker-ce

# install docker-ce, -cli and containerd.io
apt-get update

apt-get install -y \
containerd.io=1.2.13-2 \
docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)

# create docker directory
mkdir /etc/docker

# write docker daemon.json
cat <<EOF | tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload

systemctl restart docker

#######################################
#        INSTALLING kubernetes        #
#######################################
printf "\n${YELLOW}Installing kubernets... ${NC}\n"

apt-get update

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

swapoff -a

apt-get update

apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

#######################################
#       CONFIGURING Kubernetes        #
#######################################
printf "\n${YELLOW}Starting configuration... ${NC}\n"

PS3='Please chose a configuration type: '
select opt in master node quit; do
  case "$opt" in
  "master")
    printf "\n${YELLOW}Configuring Kubernetes as master... ${NC}\n"
    # Create K8s cluster https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
    kubeadm init --ignore-preflight-errors=SystemVerification --pod-network-cidr=10.244.0.0/16

    # Initialize kubectl configuration:
    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    break
    ;;
  "node")
    printf "\n${YELLOW}Configuring Kubernetes as node... ${NC}\n"

    printf "${YELLOW}input the join command: ${NC}\n"
    read -r joinCommand

    $($joinCommand)

    # Initialize kubectl configuration:
    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
    break
    ;;
  "quit")
    exit
    ;;
  *) echo "invalid option $REPLY" ;;
  esac
done

printf "\n${GREEN}Installation finished!${NC}\n"
exit
