#!/bin/bash
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
# --- 1. System Update and Dependencies ---
sudo apt update
sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl gpg software-properties-common

# --- 2. Disable Swap (Kubernetes Requirement) ---
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab # Permanently disable swap by commenting out fstab entry
sudo mount -a

# --- 3. Load Kernel Modules (Required for Containerd and CNI) ---
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# --- 4. Configure Sysctl Settings (Required for Kubernetes Networking) ---
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# --- 5. Install Docker/Containerd (CRI) ---
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y containerd.io

# --- 6. Configure Containerd for K8s (Set SystemdCgroup = true) ---
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# --- 7. Install Kubeadm, Kubelet, Kubectl ---
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# --- 8. Initialize Kubernetes Master Node (Using Containerd Socket) ---
# Use the dynamically retrieved PRIVATE_IP
sudo kubeadm config images pull --cri-socket unix:///var/run/containerd/containerd.sock

sudo kubeadm init \
    --pod-network-cidr=10.244.0.0/16 \
    --apiserver-advertise-address=$PRIVATE_IP \
    --cri-socket unix:///var/run/containerd/containerd.sock 

# --- 9. Configure Kubeconfig for Non-Root User (Necessary for kubectl commands) ---
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# --- 9. Configure Kubeconfig for Non-Root User ---
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo chmod 600 $HOME/.kube/config


# --- 10. Install CNI Plugin (Flannel) ---
# Use the copied kubeconfig to apply the CNI manifest
/usr/bin/kubectl --kubeconfig=$HOME/.kube/config apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml