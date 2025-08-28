#!/bin/bash
set -euo pipefail

echo "🔍 Checking Prometheus pods in namespace 'monitoring'..."
kubectl get pods -n monitoring
kubectl wait --for=condition=Ready pod -l app=prometheus -n monitoring --timeout=180s

echo "✅ Prometheus is running."
kubectl get svc prometheus -n monitoring