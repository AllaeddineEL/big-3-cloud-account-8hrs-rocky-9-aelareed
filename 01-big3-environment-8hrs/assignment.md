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
- title: Workstation terminal
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