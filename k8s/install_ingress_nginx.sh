#!/usr/bin/env bash

set -x

# Installing ingress-controller which is conceptually the part of platform rather than app tier.
# It should be installed decalaratively via spec.addons
# but because of ver1.6.0 with RBAC is still not supported, installing imperatively.
# The Namespace (kube-ingress), ClusterRole and bindings are created to make ingress controller
# serve requests cluster-wide.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml