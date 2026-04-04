#!/bin/bash
set -e

IMAGE_TAG="${1:-latest}"
ACR_NAME="${2:-project4acrkashm}"
NAMESPACE="${3:-devops-app}"
DEPLOYMENT="${4:-devops-flask-app}"
ACR_SERVER="${ACR_NAME}.azurecr.io"

echo "Deploying image: ${ACR_SERVER}/devops-flask-app:${IMAGE_TAG}"

kubectl set image deployment/"$DEPLOYMENT" \
  flask-app="${ACR_SERVER}/devops-flask-app:${IMAGE_TAG}" \
  -n "$NAMESPACE"

echo "Waiting for rollout to complete..."
kubectl rollout status deployment/"$DEPLOYMENT" -n "$NAMESPACE" --timeout=300s
echo "Deployment complete!"
kubectl get pods -n "$NAMESPACE"