#!/usr/bin/env bash

set -x

# constants
CLUSTER_NAME=test-kops-join.k8s.local
S3_BUCKET=s3://test-kops-join
TEMPLATES_DIR=./templates

# apply correct RBAC policy
kubectl delete -f $TEMPLATES_DIR/tiller-rbac.yaml
kubectl create -f $TEMPLATES_DIR/tiller-rbac.yaml

# init helm with correct RBAC
helm init \
    --service-account tiller \
    --history-max 200 \
    --upgrade

# check helm
helm ls


