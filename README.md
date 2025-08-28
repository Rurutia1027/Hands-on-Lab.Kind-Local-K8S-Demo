# Hands-on-Lab: Kind-Local-K8S-Demo | [![CI - Kind Local K8S Demo](https://github.com/Rurutia1027/Hands-on-Lab.Kind-Local-K8S-Demo/actions/workflows/ci-pipeline.yaml/badge.svg)](https://github.com/Rurutia1027/Hands-on-Lab.Kind-Local-K8S-Demo/actions/workflows/ci-pipeline.yaml)

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


## Repository Structure 

```
kind-local-k8s-demo/
├── setup-k8s-cluster.sh            # Script to check env + create Kind cluster (1 cp + 2 workers)
├── namespace/
│   └── namespaces.yaml             # Namespace definitions (kafka, monitoring, etc.)
├── kafka/
│   ├── kafka-cluster.yaml          # Kafka cluster manifests
│   └── kafka-exporter.yaml         # Kafka exporter deployment
├── monitoring/
│   ├── prometheus-deployment.yaml  # Prometheus deployment
│   ├── prometheus-service.yaml     # Prometheus service
│   ├── grafana-deployment.yaml     # Grafana deployment
│   └── grafana-service.yaml        # Grafana service
├── tests/
│   ├── verify-kafka.sh             # Verify Kafka cluster pods + services
│   ├── verify-prometheus.sh        # Verify Prometheus pods + services
│   └── verify-grafana.sh           # Verify Grafana pods + services
├── .github/
│   ├── kind-config.yaml            # Shared Kind cluster config (1 cp + 2 workers)
│   └── workflows/
│       └── ci.yaml                 # GitHub Actions workflow for macOS Kind validation
└── README.md
```

## Quick Start 

### 0. Environment Check and Cluster Set up
```bash
chmod + x setup-kind.sh 

./setup-kind.sh 
```

This script will verify prerequisites, create the Kind cluster, and configure your kubeconfig automatically.

### 1. Create namespaces 
```bash 
kubectl apply -f namespace/namespace.yaml
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

## Local Kind Kubernetes Cluster Access Map

| Component       | Pod Name / Selector      | ClusterIP Service Port | NodePort | Localhost (macOS) | Notes                                |
|-----------------|------------------------|----------------------|----------|-----------------|--------------------------------------|
| Kafka           | kafka-0 / app: kafka    | 9092                 | 30092    | localhost:30092 | Single-node Kafka KRaft mode         |
| Kafka Exporter  | kafka-exporter / app: kafka-exporter | 9308  | 9308     | localhost:9308  | Exposes Kafka metrics for Prometheus |
| Prometheus      | prometheus / app: prometheus | 9090            | 30900    | localhost:30900 | Prometheus web UI + metrics scrape   |
| Grafana         | grafana / app: grafana  | 3000                 | 32000    | localhost:32000 | Grafana web UI                        |

## Accessing Services from macOS/Linux 

If you did **not map NodePorts in `kind-config.yaml`** during cluster creation, you can still access the services using `kubectl port-forward`. Examples: 

```bash 
# Kafka Exporter
kubectl port-forward svc/kafka-exporter 9308:9308 -n kafka

# Prometheus
kubectl port-forward svc/prometheus 9090:9090 -n monitoring

# Grafana
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```

**Note: port-forward binds the service to localhost temporarily. NodePort mapping in Kind is preferred for continuous localhost access.**


### Notes
- **ClusterIP Service Port** -> Internal Kubernetes port, used by Pods to talk to each other
- **NodePort** -> Exposes Services to the Node (Kind container)
- **Localhost** -> Maps **NodePort** to macOS host via `extraPortMappings` in `kind-config.yaml`
- Verify those via commands below: 
```bash 
kubectl get pods -n kafka
kubectl get svc -n kafka
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

## Tips 
- Prometheus is configured to scrape Kafka Exporter metrics.
- You can create Grafana dashboards to visualize Kafka cluster metrics.
- All mainfests are designed to run **locally on Kind**, ideal for CKA practice or testing GitOps pipelines. 

## Optional Steps 
- Add your own Helm charts
- Extend Prometheus scrape configs 
- Add Ingress for more services 
- Use GitOps workflows with **ArgoCD** or **FluxCD** to sync manifests 


## Cleanup 
To delete the local Kind setup K8S cluster:

```bash 
kind delete cluster --name kind-local-k8s
```

**Enjoy spinning up a complete monitoring demo in your local Kind Kubernetes cluster with minimal effort!**
