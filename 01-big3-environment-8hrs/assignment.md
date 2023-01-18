---
slug: big3-environment-8hrs
id: qja6sfnrivvc
type: challenge
title: Multi-cloud account environment
teaser: Use an 8-hour-duration sandbox configured with AWS, Azure and GCP credentials.
notes:
- type: text
  contents: Please wait while we provision the instance and the cloud accounts.
tabs:
- title: Workstation terminal 1
  type: terminal
  hostname: cloud-sandbox
- title: Workstation terminal 2
  type: terminal
  hostname: cloud-sandbox
- title: Cloud account access
  type: service
  hostname: cloud-account-details
  path: /
  port: 80
- title: IDE
  type: service
  hostname: cloud-sandbox
  port: 8080
- title: Consul UI
  type: service
  hostname: cloud-sandbox
  path: /
  port: 8443
difficulty: basic
timelimit: 28800
---

Sandbox environment
===============

This challenge provides an 8-hour environment with provisioned AWS, Azure and GCP accounts.


You will use Terraform to provision these services in the background while you set up Consul in the next few assignments. <br>

Start with Vault. <br>

```
cd /root/terraform/vault
terraform plan
nohup terraform apply -auto-approve > /root/terraform/vault/terraform.out &
```

```
aws eks \
    update-kubeconfig \
    --region $(terraform -chdir=terraform/aws output -raw region) \
    --name $(terraform -chdir=terraform/aws output -raw cluster_name) \
    --alias=$(terraform -chdir=terraform/aws output -raw cluster_name)
```

create consul Namespace in EKS cluster

```
kubectl create ns consul
```

create the secret with name consul-ent-license and key key

```
vim consul.hclic
```

```
kubectl create --namespace consul secret generic consul-ent-license \
  --from-literal=key=$(cat consul.hclic | tr -d '\n')
```

```
helm repo add hashicorp https://helm.releases.hashicorp.com
```

```
helm install consul hashicorp/consul --values big-3-cloud-account-8hrs-rocky-9-aelareed/assets/terraform/helm/aws-values.yaml --namespace consul --version "1.0.2"
```


```
az login
```

```
az aks get-credentials --resource-group consul-multicloud --name consul-aks -a
```

create consul Namespace in AKS cluster

```
kubectl create ns consul
```

```
kubectl --context consul-eks get secret consul-consul-ca-cert -n consul -o yaml | \
kubectl --context consul-aks-admin apply -f -
```

```
kubectl --context consul-eks get secret consul-consul-ca-key -n consul -o yaml | \
kubectl --context consul-aks-admin apply -f -
```

```
kubectl --context consul-eks get secret consul-consul-gossip-encryption-key -n consul -o yaml | \
kubectl --context consul-aks-admin apply -f -
```

```
kubectl --context consul-eks get secret consul-consul-partitions-acl-token -n consul -o yaml | \
kubectl --context consul-aks-admin apply -f -
```

```
kubectl --context consul-eks get consul-consul-ca-key -n consul -o yaml | \
kubectl --context consul-aks-admin apply -f -
```

