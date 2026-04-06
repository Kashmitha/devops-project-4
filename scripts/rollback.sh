#!bin/bash
set -e

NAMESPACE="${1:-devops-app}"
DEPLOYMENT="${2:-devops-flask-app}"
REVISION="${3:-}"

echo "Rolling back $DEPLOYMENT in namespace $NAMESPACE..."

if [ -n "$REVISION" ]; then
  kubectl rollout undo deployment/"$DEPLOYMENT" -n "$NAMESPACE" --to-revision="$REVISION"
else
  kubectl rollout undo deployment/"$DEPLOYMENT" -n "$NAMESPACE"
fi

echo "Waiting for rollback to complete..."
kubectl rollout status deployment/"$DEPLOYMENT" -n "$NAMESPACE"
echo "Rollback complete."
kubectl get pods -n "$NAMESPACE"