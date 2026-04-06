# DevOps Project 4 — Kubernetes Deployment with Rolling Updates & Monitoring on Azure AKS

[![CI/CD Pipeline](https://github.com/YOUR_USERNAME/devops-project-4/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/YOUR_USERNAME/devops-project-4/actions/workflows/ci-cd.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33.7-blue)](https://kubernetes.io)
[![AKS](https://img.shields.io/badge/Azure_AKS-1.33.7-0078D4)](https://azure.microsoft.com/products/kubernetes-service)

---

## Overview

Production-grade AKS cluster deployment with:

- Zero-downtime rolling updates
- Horizontal Pod Autoscaling
- Full observability via Prometheus and Grafana
- Automated CI/CD through GitHub Actions

---

## Architecture

```
GitHub → GitHub Actions → ACR → AKS (Kubernetes 1.33.7)

Namespaces:
├── devops-app
│   ├── Deployment (3 replicas)
│   ├── Service (LoadBalancer)
│   ├── HPA (2–6 pods)
│   └── ResourceQuota
│
└── monitoring
    ├── Prometheus
    └── Grafana
```

---

## Tech Stack

| Tool             | Version               | Purpose                     |
| ---------------- | --------------------- | --------------------------- |
| Kubernetes (AKS) | 1.33.7                | Container orchestration     |
| Azure Linux      | 3.0                   | Node OS                     |
| Node VM Size     | Standard_DC4as_v5     | AKS node pool               |
| Terraform        | 1.14 + AzureRM 4.64   | Infrastructure provisioning |
| Docker           | Latest                | Container build             |
| Helm             | 3.x                   | Monitoring stack deployment |
| Prometheus       | kube-prometheus-stack | Metrics collection          |
| Grafana          | Latest                | Metrics visualisation       |
| GitHub Actions   | Latest                | CI/CD automation            |

---

## Key Concepts Demonstrated

- Zero-downtime rolling updates (`maxSurge=1`, `maxUnavailable=0`)
- Kubernetes rollback from failed deployment
- Liveness, readiness, and startup probes
- Horizontal Pod Autoscaler (CPU + memory triggers)
- Resource requests and limits with ResourceQuota
- Multi-stage Docker builds (non-root user)
- Dynamic image tagging via GitHub SHA
- AKS cluster autoscaler (1–3 nodes)

---

## Usage

### 1. Provision Infrastructure

```bash
cd terraform
terraform init
terraform apply -var-file="environments/dev.tfvars"
```

### 2. Deploy Application

```bash
kubectl apply -f k8s/
```

### 3. Rolling Update

```bash
./scripts/deploy.sh 1.1.0 devopsproject4acr devops-app devops-flask-app
```

### 4. Rollback

```bash
./scripts/rollback.sh devops-app devops-flask-app
```

### 5. Teardown Infrastructure

```bash
cd terraform
terraform destroy -var-file="environments/dev.tfvars"
```

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
