#!/bin/bash

helm upgrade --install auth-operator . \
  --namespace openbao-system --force-conflicts --create-namespace --values ./values.yaml