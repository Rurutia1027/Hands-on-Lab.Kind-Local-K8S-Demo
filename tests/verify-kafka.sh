#!/bin/bash
set -euo pipefail

echo "🔍 Checking Kafka pods in namespace 'kafka'..."
kubectl get pods -n kafka
kubectl wait --for=condition=Ready pod -l app=kafka -n kafka --timeout=180s

echo "✅ Kafka cluster is up."
kubectl get svc -n kafka