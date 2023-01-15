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

create the secret with name consul-ent-license and key key

```
secret=$(cat 1931d1f4-bdfd-6881-f3f5-19349374841f.hclic)
kubectl create secret generic consul-ent-license --from-literal="key=${secret}" -n consul

```
