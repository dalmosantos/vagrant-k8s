# -*- mode: ruby -*-
# vi: set ft=ruby :
domain = "kubernetes.lab"
control_plane_endpoint = "k8s-control." + domain + ":6443"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 3072
    vb.cpus = 2
  end

  config.vm.define "controlplane" do |node|
    node.vm.hostname = "controlplane"
    node.vm.network "private_network", ip: "192.168.56.10"
    node.vm.provision "shell", name: "configure-kubernetes-controlplane", path: "configure-kubernetes-controlplane.sh", privileged: false
  end

  (1..2).each do |i|
    config.vm.define "worker-#{i}" do |node|
      node.vm.hostname = "worker-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{10 + i}"
      node.vm.provision "shell", name: "configure-kubernetes-workers", path: "configure-kubernetes-workers.sh", privileged: false
    end
  end

  config.vm.provision "shell", name: "install-essential-tools", path: "install-essential-tools.sh", privileged: false
  config.vm.provision "shell", name: "allow-bridge-nf-traffic", path: "allow-bridge-nf-traffic.sh", privileged: false
  config.vm.provision "shell", name: "install-containerd", path: "install-containerd.sh", privileged: false
  config.vm.provision "shell", name: "install-kubeadm", path: "install-kubeadm.sh", privileged: false
  config.vm.provision "shell", name: "update-kubelet-config", path: "update-kubelet-config.sh", args: ["enp0s8"], privileged: false, reboot: true

end
