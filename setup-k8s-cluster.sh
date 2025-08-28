#!/bin/sh

CLUSTER_NAME="kind-local-k8s"

kind create cluster --name kind-local-k8s --config configs/kind-config.yaml