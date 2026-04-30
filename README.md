# Auth Operator Helm Chart

This Helm chart deploys the `auth-operator` on a Kubernetes cluster. The `auth-operator` manages authentication-related resources and integrates with OpenBao for secure credential storage. **Note: OpenBao is currently the only supported backend store.**

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- OpenBao

## Installation

To install the chart with the release name `auth-operator`:

```bash
helm install auth-operator .
```

## Configuration

The following table lists the configurable parameters of the Auth Operator chart and their default values.

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.serviceType` | Service type (only `ClusterIP` is supported) | `ClusterIP` |
| `service.port` | Service port | `8081` |

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.pullPolicy` | Image pull policy (`Always`, `IfNotPresent`, `Never`) | `IfNotPresent` |
| `image.tag` | Image tag for the auth-operator | `latest` |

### Store Configuration (OpenBao)

Currently, OpenBao is the only supported backend store for the auth-operator.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `store.openbao.enabled` | Enable OpenBao store (must be `true` as it's the only supported store) | `true` |
| `store.openbao.vaultADDR` | OpenBao vault address | `http://openbao-release.openbao-system.svc.cluster.local:8200` |
| `store.openbao.proxy.image.tag` | Image tag for the OpenBao proxy | `latest` |
| `store.openbao.proxy.authMethod.token.enabled` | Enable OpenBao token authentication | `false` |
| `store.openbao.proxy.authMethod.token.secret.name` | Name of the kubernetes secret where the token is stored | `openbao-token` |
| `store.openbao.proxy.authMethod.token.secret.key` | Key of the kubernetes secret containing the token | `token` |
| `store.openbao.proxy.authMethod.kubernetes.enabled` | Enable OpenBao kubernetes authentication | `true` |
| `store.openbao.proxy.authMethod.kubernetes.role` | The role the kubernetes service account will assume in OpenBao | `auth-operator` |

### Kubernetes API Configuration

The operator requires either a `ClusterRole` or a `Role` to be enabled.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kubeAPI.serviceAccount.create` | Whether the helm chart will create the service account | `true` |
| `kubeAPI.serviceAccount.name` | Name of the service account | `auth-operator` |
| `kubeAPI.serviceAccount.annotations` | Annotations for the service account | `{}` |
| `kubeAPI.clusterRole.enabled` | Enable cluster role | `true` |
| `kubeAPI.clusterRole.name` | Name of the cluster role | `auth-operator-cluster-role` |
| `kubeAPI.role.enabled` | Enable role | `false` |
| `kubeAPI.role.name` | Name of the role | `auth-operator-role` |

### Probes and Environment

| Parameter | Description | Default |
|-----------|-------------|---------|
| `probe.livenessProbe.httpGet.path` | Path to the liveness probe | `/healthz` |
| `probe.livenessProbe.httpGet.port` | Port of the liveness probe | `8081` |
| `probe.readinessProbe.httpGet.path` | Path to the readiness probe | `/readyz` |
| `probe.readinessProbe.httpGet.port` | Port of the readiness probe | `8081` |
| `environment` | List of environment variables (name/value pairs) | `[]` |

## RBAC Requirements

If `kubeAPI.clusterRole.enabled` is `true`, a `ClusterRole` and `ClusterRoleBinding` will be created. If `kubeAPI.role.enabled` is `true`, a `Role` and `RoleBinding` will be created. Exactly one of these must be enabled.

## OpenBao Authentication

When using the `kubernetes` authentication method for OpenBao, the service account used by the operator must have the necessary permissions to authenticate with the OpenBao API.

## Uninstalling the Chart

To uninstall/delete the `auth-operator` deployment:

```bash
helm uninstall auth-operator
```
