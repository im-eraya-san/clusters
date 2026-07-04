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

    echo "[+] Installing kubelet kubeadm"
    sudo apt-get install -y kubelet kubeadm 
    sudo apt-mark hold kubelet kubeadm

    echo "[+] Enable the kubelet service before running kubeadm [+]"
    sudo systemctl enable --now kubelet

    echo "[+] Installing containerd [+]"
    sudo apt install -y containerd

    echo "[+] Setting up ip forward [+]"
    sudo sysctl -w net.ipv4.ip_forward=1
}


if [ "$(id -u)" -eq 0 ]; then
  install_k8s
else
    echo "This script must be run as root"
    exit 1
fi
