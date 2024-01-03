#!/bin/bash


# Specify the control plane's domain
DOMAIN="kubernetes.lab"
KUBERNETES_VERSION=$(kubectl version --client | awk -Fv '/Client Version: /{print $2}')
IP_ADDRESS=$(hostname -I | awk '{print $2}')

# Restart kubelet

sudo systemctl stop kubelet
sleep 15
sudo systemctl start kubelet

### Pull from default registry: registry.k8s.io ###
sudo kubeadm config images pull --kubernetes-version=$KUBERNETES_VERSION 

# Initialize Kubernetes controlplane and save token and controlplane IP to files
sudo kubeadm init --kubernetes-version=$KUBERNETES_VERSION --apiserver-advertise-address=$IP_ADDRESS --pod-network-cidr=10.244.0.0/16  --ignore-preflight-errors=NumCPU | tee /vagrant/kubeinit.log

# Extract the token and controlplane IP from the init log
echo "Save the following command and run it on worker nodes to join the cluster:"
sudo kubeadm token create --print-join-command > /vagrant/kubeadm_join_cmd

echo "Kubernetes control plane installed successfully."
echo "You can now join worker nodes using the command: cat /vagrant/kubeadm_join_cmd"

kubectl cluster-info


# Set up kubeconfig for the vagrant user
mkdir -p $HOME/.kube 
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo cp -i /etc/kubernetes/admin.conf /vagrant/kubeconfig
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a network plugin (e.g., Calico)
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Install kubectl autocompletion
echo "source <(kubectl completion bash)" >> $HOME/.bashrc

# Install Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

