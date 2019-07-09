#!/usr/bin/env bash

set -x

# constants
CLUSTER_NAME=test-kops-join.k8s.local
S3_BUCKET=s3://test-kops-join
TEMPLATES_DIR=./templates

# create cluster
kops delete cluster \
    --name $CLUSTER_NAME \
    --state $S3_BUCKET \
    --yes