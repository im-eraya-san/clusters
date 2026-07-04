# Kubernetes Cluster Provisioning with kubeadm

A simple Bash-based automation project to provision a Kubernetes cluster using **kubeadm** on Ubuntu-based systems.

This project contains two scripts:

* **master-node.sh** – Installs Kubernetes components and initializes the control plane.
* **worker-node.sh** – Installs Kubernetes components required for worker nodes.

The goal of this project is to simplify the repetitive steps involved in setting up a Kubernetes cluster for learning, lab environments, and personal projects.

---

## Features

* Installs Kubernetes v1.36 packages
* Installs Containerd container runtime
* Disables swap
* Enables kubelet service
* Configures Kubernetes APT repository
* Initializes the Kubernetes control plane
* Automatically configures `kubectl`
* Deploys Calico CNI plugin
* Prepares worker nodes to join the cluster

---

## Project Structure

```text
scripts/
├── master-node.sh
└── worker-node.sh
```

---

## Prerequisites

* Ubuntu 22.04/24.04 (or any Debian-based distribution)
* Root privileges
* Internet connectivity
* Minimum:

  * 2 CPU
  * 2 GB RAM (4 GB recommended for control plane)
  * Swap disabled

---

## Master Node Installation

Clone the repository:

```bash
git clone https://github.com/<your-username>/<repository>.git
cd <repository>/scripts
```

Make the script executable:

```bash
chmod +x master-node.sh
```

Run the script as root:

```bash
sudo ./master-node.sh
```

The script performs the following:

1. Updates package repositories
2. Disables swap
3. Adds the Kubernetes APT repository
4. Installs:

   * kubeadm
   * kubelet
   * kubectl
5. Installs Containerd
6. Enables kubelet
7. Initializes the Kubernetes cluster using `kubeadm init`
8. Configures `kubectl`
9. Installs the Calico networking plugin

---

## Worker Node Installation

On every worker node:

```bash
chmod +x worker-node.sh
sudo ./worker-node.sh
```

This script installs:

* kubeadm
* kubelet
* Containerd

and prepares the node to join the cluster.

---

## Join Worker Nodes

After the control plane has been initialized, obtain the join command:

```bash
kubeadm token create --print-join-command
```

Example:

```bash
kubeadm join <MASTER-IP>:6443 \
--token <TOKEN> \
--discovery-token-ca-cert-hash sha256:<HASH>
```

Run the generated command on each worker node.

---

## Verify the Cluster

On the control plane:

```bash
kubectl get nodes
```

Expected output:

```text
NAME          STATUS   ROLES           AGE   VERSION
master-node   Ready    control-plane   2m    v1.36.x
worker-01     Ready    <none>          1m    v1.36.x
worker-02     Ready    <none>          1m    v1.36.x
```

---

## Networking

This project installs **Calico** as the default CNI plugin.

```bash
kubectl get pods -n kube-system
```

Verify that the Calico pods are in the `Running` state.

---

## Notes

* The scripts temporarily disable swap using:

```bash
swapoff -a
```

For production environments, you should also remove or comment out the swap entry in `/etc/fstab` to keep swap disabled after reboot.

The scripts also enable IPv4 forwarding:

```bash
sysctl -w net.ipv4.ip_forward=1
```

For persistence across reboots, update the appropriate `sysctl` configuration.

---

## Tested On

* Ubuntu 22.04 LTS
* Ubuntu 24.04 LTS
* Kubernetes v1.36
* Containerd

---

## Future Improvements

* Support for HA control plane
* Automatic worker node join
* Parameterized Kubernetes version
* Containerd configuration generation
* Persistent sysctl configuration
* Automatic `/etc/fstab` swap removal
* Error handling and logging
* Support for additional CNI plugins (Flannel, Cilium, Weave)

---

## Disclaimer

These scripts are intended for educational purposes, home labs, and development environments. Before using them in production, review and adapt the configuration to meet your organization's security, networking, and operational requirements.

---

## License

This project is licensed under the MIT License.

