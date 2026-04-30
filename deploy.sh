#!/bin/bash

helm upgrade --install auth-operator . \
  --namespace auth-system --force-conflicts --create-namespace --values ./values.yaml