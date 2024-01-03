#!/bin/bash

# Get the join command from the control plane (execute on the control plane)
JOIN_CMD=/vagrant/kubeadm_join_cmd

echo "Executing join command:"
cat $JOIN_CMD | sudo bash

echo "Worker node joined successfully to the Kubernetes control plane."
