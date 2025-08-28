#!/bin/bash
set -euo pipefail

echo "🔍 Checking Grafana pods in namespace 'monitoring'..."
kubectl get pods -n monitoring
kubectl wait --for=condition=Ready pod -l app=grafana -n monitoring --timeout=180s

echo "✅ Grafana is running."
kubectl get svc grafana -n monitoring