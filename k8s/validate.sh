#!/usr/bin/env bash

set -x

# replace cluster configin s3 bucket
kops validate cluster \
    --state s3://test-kops-join \
    -v10
