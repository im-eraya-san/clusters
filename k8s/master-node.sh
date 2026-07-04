#!/bin/bash

install_k8s(){
    echo "[+] Updating the system [+]"
    apt-get update

    echo "[+] Disabling the swap  [+]"
    swapoff -a
    echo "[+] Swap is Disabled    [+]"


    echo "[+] Download the public signing key for the Kubernetes package repositories [+]"

    sudo apt-get install -y apt-transport-https ca-certificates curl gpg
    sudo mkdir -p -m 755 /etc/apt/keyrings
    sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg 

    echo "[+] Adding keyring [+]"
    sudo echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

    echo "[+] Updating the system [+]"
    sudo apt-get update

    echo "[+] Installing kubelet kubeadm kubectl"
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

    echo "[+] Enable the kubelet service before running kubeadm [+]"
    sudo systemctl enable --now kubelet

    echo "[+] Installing containerd [+]"
    sudo apt install -y containerd

    echo "[+] Setting up ip forward [+]"
    sudo sysctl -w net.ipv4.ip_forward=1
}

create_cluster(){

    sudo kubeadm init
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config 
    export KUBECONFIG=/etc/kubernetes/admin.conf

    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

    echo "[+] Comment swap from /etc/fstab"
}


if [ "$(id -u)" -eq 0 ]; then
  install_k8s
  create_cluster
else
    echo "This script must be run as root"
    exit 1
fi
