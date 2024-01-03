#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Define the domain
DOMAIN="kubernetes.lab"

# Get the IP address
IP_ADDRESS=$(hostname -I | awk '{print $2}')

# set fastest mirrors
newMirror='mirror://mirrors.ubuntu.com/mirrors.txt'
sudo sed -i "s|deb [a-z]*://[^ ]* |deb ${newMirror} |g" /etc/apt/sources.list

sudo rm -rf /var/lib/apt/lists/* 
sudo apt update --fix-missing
sudo apt --quiet --yes dist-upgrade
sudo apt --quiet --yes install git vim curl wget htop tmux jq net-tools gnupg2 software-properties-common apt-transport-https ca-certificates

# Remove existing /etc/hosts file
sudo rm /etc/hosts /vagrant/hosts

# Add entries for control plane and worker nodes
cat <<EOL > /vagrant/hosts
### Hosts File ###
127.0.0.1   localhost

# Control plane
$IP_ADDRESS   controlplane.$DOMAIN   controlplane

# Worker Nodes
EOL

for i in {1..2}; do
    IP_ADDRESS=$(echo $IP_ADDRESS | awk -F'.' '{print $1"."$2"."$3"."$4 + 1}')
    echo "$IP_ADDRESS   worker-$i.$DOMAIN   worker-$i" >> /vagrant/hosts
done

# Copy /vagrant/hosts to /etc/hosts
sudo cp /vagrant/hosts /etc/hosts


# disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
