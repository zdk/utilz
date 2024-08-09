#!/bin/bash

# create cluster
# kubeletExtraArgs:node-labels:"ingress-ready=true" -> route traffic from http://localhost to services inside the cluster
cat <<EOF | kind create cluster --name dev --config=-                                                                                                                                             main
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
- role: worker
EOF

# make sure kube-context is using above cluster
# install nginx ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# install example app (conference-app)
helm install conference oci://docker.io/salaboy/conference-app --version v1.0.0
