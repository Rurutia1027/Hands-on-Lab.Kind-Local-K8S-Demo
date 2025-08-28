# Hands-on-Lab: Kind-Local-K8S-Demo

This repository provides a **ready-to-run local Kubernetes lab** using Kind, including: 
- Kafka cluster 
- Kafka Exporter 
- Prometheus 
- Grafana dashboards

It is designed to verify your **local Kind-based Kubernetes cluster**, run monitoring for Kafka, and provide a live Grafana dashboard UI. 

## Prerequisites 

- Docker Desktop (macOS)
- Kind installed 
- kubectl installed and configured 
- Helm (optional, for future GitOps or Helm-based deployments)

This repo contains a script `setup-kind.sh` that will: 
- Check the environment (Docker version, kubectl, Kind)
- Create a Kind cluster with 1 control plane + 2 worker nodes
- Apply namespaces and prepare the cluster for demo deployments


## Quick Start 

### 0. Environment Check and Cluster Set up
```bash
chmod + x setup-kind.sh 

./setup-kind.sh 
```

This script will verify prerequisites, create the Kind cluster, and configure your kubeconfig automatically.

### 1. Create namespaces 
```bash 
kubectl apply -f namespaces.yaml
```

### 2. Deploy Kafka Cluster and Its Exporter 
```bash 
kubectl apply -f kafka/kafka-cluster.yaml
kubectl apply -f kafka/kafka-exporter.yaml 
```

### 3. Deploy Prometheus and Grafana

```bash 
kubectl apply -f monitoring/prometheus-deployment.yaml 
kubectl apply -f monitoring/prometheus-service.yaml 
kubectl apply -f monitoring/grafana-deployment.yaml
kubectl apply -f monitoring/grafana-service.yaml 
```

### 4. Access Grafana 
```bash 
kubectl get svc -n monitoring 
```

- **NodePort** will show the port to access Grafana on localhost.
- Default login: `admin/admin`.

> This allows you to see Kafka cluster metrics visualized Grafana immediately! 

## Notes
- Prometheus is configured to scrape Kafka Exporter metrics.
- You can create Grafana dashboards to visualize Kafka cluster metrics.
- All mainfests are designed to run **locally on Kind**, ideal for CKA practice or testing GitOps pipelines. 

## Optional Steps 
- Add your own Helm charts
- Extend Prometheus scrape configs 
- Add Ingress for more services 
- Use GitOps workflows with **ArgoCD** or **FluxCD** to sync manifests 

**Enjoy spinning up a complete monitoring demo in your local Kind Kubernetes cluster with minimal effort!**
