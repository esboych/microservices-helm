#!/usr/bin/env bash

set -x

# constants
CLUSTER_NAME=test-kops-join.k8s.local
S3_BUCKET=s3://test-kops-join
TEMPLATES_DIR=./templates

# note that ~/.kube/config shouldn't be empty to enable this command to finish
# generate cluster.spec out of parameterised template
kops toolbox template \
    --values $TEMPLATES_DIR/values.yaml \
    --template $TEMPLATES_DIR/template.yaml \
    --output $TEMPLATES_DIR/cluster.yaml

# replace cluster configin s3 bucket
kops replace \
    -f $TEMPLATES_DIR/cluster.yaml \
    --state $S3_BUCKET \
    --force

# creating secret
kops create secret \
    --name $CLUSTER_NAME sshpublickey admin -i ~/.ssh/id_rsa.pub \
    --state $S3_BUCKET

# check changes
kops update cluster \
    --name $CLUSTER_NAME \
    --state $S3_BUCKET


# create cluster
kops update cluster \
    --name $CLUSTER_NAME \
    --state $S3_BUCKET \
    --yes

# create cluster
kops rolling-update cluster \
    --name $CLUSTER_NAME \
    --state $S3_BUCKET \
    --yes --cloudonly --force
