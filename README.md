# Auth Operator Helm Chart

WORK IN PROGRES - INFORMATION MAY OR MAY NOT BE UP TO DATE

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

| Parameter             | Description                      | Default     |
|-----------------------|----------------------------------|-------------|
| `service.serviceType` | Service type (enum: `ClusterIP`) | `ClusterIP` |
| `service.port`        | Service port                     | `8081`      |

### Image Configuration

| Parameter                   | Description                                                            | Default        |
|-----------------------------|------------------------------------------------------------------------|----------------|
| `image.operator.pullPolicy` | Image pull policy for the operator (`Always`, `IfNotPresent`, `Never`) | `IfNotPresent` |
| `image.operator.tag`        | Image tag for the operator                                             | `1.0.35`       |
| `image.apiAuth.pullPolicy`  | Image pull policy for the apiAuth (`Always`, `IfNotPresent`, `Never`)  | `IfNotPresent` |
| `image.apiAuth.tag`         | Image tag for the apiAuth                                              | `1.0.5`        |

### Store Configuration (OpenBao)

Currently, OpenBao is the only supported backend store for the auth-operator.

**Uniqueness Rule:** If `store.openbao.enabled` is `true`, then `store.openbao.vaultADDR` and `store.openbao.proxy` are **required**.

| Parameter                         | Description                                                                     | Default                                                                |
|-----------------------------------|---------------------------------------------------------------------------------|------------------------------------------------------------------------|
| `store.openbao.enabled`           | Enable OpenBao store                                                            | `true`                                                                 |
| `store.openbao.vaultADDR`         | OpenBao vault address                                                           | `https://openbao-release.openbao-system.svc.cluster.local:8200`        |
| `store.openbao.kv2MountPath`      | the OpenBao kv2 mount path                                                      | `kv`                                                                   |
| `store.openbao.masterSecretPath`  | the OpenBao master secret path. This path is from the kv2MountPath              | `client-credentials`                                                   |
| `store.openbao.transitMountPath`  | the OpenBao transit mount path                                                  | `transit`                                                              |
| `store.openbao.transitSigningKey` | the name of the OpenBao transit signing key                                     | `api-auth-signing-key`                                                 |

#### OpenBao TLS Configuration

**Uniqueness Rule:** If `store.openbao.tls.selfSigned` is `true`, then `store.openbao.tls.secretName` and `store.openbao.tls.caCertKey` are **required**.

| Parameter                      | Description                                                                                                                                                                 | Default                  |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| `store.openbao.tls.selfSigned` | Whether the OpenBao server utilizes a self-signed certificate. This is useful when the openbao proxy or another client wouldn't be able to validate the certificate without the CA certificate. | `true`                   |
| `store.openbao.tls.secretName` | The name of the secret containing the TLS certificate and key                                                                                                               | `internal-openbao-cert`  |
| `store.openbao.tls.caCertKey`  | The name of the data key in the secret containing the CA certificate                                                                                                        | `ca.crt`                 |

#### OpenBao Proxy Configuration

| Parameter                                                   | Description                                                                                              | Default                                         |
|-------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| `store.openbao.proxy.image.tag`                             | Image tag for the OpenBao proxy                                                                          | `1.0.14-alpine3.23-openbao_proxy2.5`            |
| `store.openbao.proxy.authMethod.openBaoUsesSelfJwtReviewer` | whether the OpenBao server uses the OpenBao self JWT reviewer token for kubernetes auth engine            | `true`                                          |

#### OpenBao Authentication Methods

The `authMethod` configuration applies to both `operator` and `apiAuth`.

**Uniqueness Rule:** For each component (`operator` and `apiAuth`), you must enable **exactly one** authentication method: either `token` or `kubernetes`.

##### Operator Auth Method

| Parameter                                                    | Description                                                                                                   | Default         |
|--------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-----------------|
| `store.openbao.proxy.authMethod.operator.token.enabled`      | Enable OpenBao token authentication method (mutually exclusive with `kubernetes`)                             | `false`         |
| `store.openbao.proxy.authMethod.operator.token.secret.name`  | Name of the kubernetes secret where the token is stored (Required if `token.enabled` is true)                 | `openbao-token` |
| `store.openbao.proxy.authMethod.operator.token.secret.key`   | Key of the kubernetes secret containing the token (Required if `token.enabled` is true)                       | `token`         |
| `store.openbao.proxy.authMethod.operator.kubernetes.enabled` | Enable OpenBao kubernetes authentication method (mutually exclusive with `token`)                             | `true`          |
| `store.openbao.proxy.authMethod.operator.kubernetes.role`    | The role the kubernetes service account will assume upon successful authentication in OpenBao (Required if `kubernetes.enabled` is true) | `auth-operator` |

##### API Auth Auth Method

| Parameter                                                   | Description                                                                                                   | Default                  |
|-------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|--------------------------|
| `store.openbao.proxy.authMethod.apiAuth.token.enabled`      | Enable OpenBao token authentication method (mutually exclusive with `kubernetes`)                             | `false`                  |
| `store.openbao.proxy.authMethod.apiAuth.token.secret.name`  | Name of the kubernetes secret where the token is stored (Required if `token.enabled` is true)                 | `openbao-token`          |
| `store.openbao.proxy.authMethod.apiAuth.token.secret.key`   | Key of the kubernetes secret containing the token (Required if `token.enabled` is true)                       | `token`                  |
| `store.openbao.proxy.authMethod.apiAuth.kubernetes.enabled` | Enable OpenBao kubernetes authentication method (mutually exclusive with `token`)                             | `true`                   |
| `store.openbao.proxy.authMethod.apiAuth.kubernetes.role`    | The role the kubernetes service account will assume upon successful authentication in OpenBao (Required if `kubernetes.enabled` is true) | `auth-operator-api-auth` |

### Kubernetes API Configuration

**Uniqueness Rule:** For both `operator` and `apiAuth`, you must enable **exactly one** of `clusterRole.enabled` or `role.enabled`.

#### Operator

| Parameter                                     | Description                                                                                                                                                                                           | Default                      |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| `kubeAPI.operator.serviceAccount.create`      | Whether the helm chart will create the service account                                                                                                                                                | `true`                       |
| `kubeAPI.operator.serviceAccount.name`        | Name of the service account. If create is set to false, this value will be used to find the existing service account                                                                                  | `auth-operator`              |
| `kubeAPI.operator.serviceAccount.annotations` | Annotations for the service account                                                                                                                                                                   | `{}`                         |
| `kubeAPI.operator.clusterRole.enabled`        | Enable cluster role (mutually exclusive with `role`)                                                                                                                                                  | `true`                       |
| `kubeAPI.operator.clusterRole.name`           | Name of the cluster role (Required if `clusterRole.enabled` is true)                                                                                                                                  | `auth-operator-cluster-role` |
| `kubeAPI.operator.role.enabled`               | Enable role (mutually exclusive with `clusterRole`)                                                                                                                                                   | `false`                      |
| `kubeAPI.operator.role.name`                  | Name of the role (Required if `role.enabled` is true)                                                                                                                                                 | `auth-operator-role`         |

#### API Auth

| Parameter                                     | Description                                                                                                                                                                                           | Default                  |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| `kubeAPI.apiAuth.serviceAccount.create`       | Whether the helm chart will create the service account                                                                                                                                                | `true`                   |
| `kubeAPI.apiAuth.serviceAccount.name`         | Name of the service account. If create is set to false, this value will be used to find the existing service account                                                                                  | `auth-operator-api-auth` |
| `kubeAPI.apiAuth.serviceAccount.annotations`  | Annotations for the service account                                                                                                                                                                   | `{}`                     |
| `kubeAPI.apiAuth.clusterRole.enabled`         | Enable cluster role (mutually exclusive with `role`)                                                                                                                                                  | `true`                   |
| `kubeAPI.apiAuth.clusterRole.name`            | Name of the cluster role (Required if `clusterRole.enabled` is true)                                                                                                                                  | `api-auth-cluster-role`  |
| `kubeAPI.apiAuth.role.enabled`                | Enable role (mutually exclusive with `clusterRole`)                                                                                                                                                   | `false`                  |
| `kubeAPI.apiAuth.role.name`                   | Name of the role (Required if `role.enabled` is true)                                                                                                                                                 | `api-auth-role`          |

### Probes and Environment

| Parameter                           | Description                                                                                      | Default    |
|-------------------------------------|--------------------------------------------------------------------------------------------------|------------|
| `probe.livenessProbe.httpGet.path`  | Path to the liveness probe                                                                       | `/healthz` |
| `probe.livenessProbe.httpGet.port`  | Port of the liveness probe                                                                       | `8081`     |
| `probe.readinessProbe.httpGet.path` | Path to the readiness probe                                                                      | `/readyz`  |
| `probe.readinessProbe.httpGet.port` | Port of the readiness probe                                                                      | `8081`     |
| `environment`                       | Environment variables to be set in the auth-operator deployment (list of name/value pairs)       | `[]`       |

## RBAC Requirements

If `kubeAPI.operator.clusterRole.enabled` is `true`, a `ClusterRole` and `ClusterRoleBinding` will be created. If `kubeAPI.operator.role.enabled` is `true`, a `Role` and `RoleBinding` will be created. Exactly one of these must be enabled.

## OpenBao Authentication

When using the `kubernetes` authentication method for OpenBao, the service account used by the operator must have the necessary permissions to authenticate with the OpenBao API.

## OpenBao Policies

The following OpenBao policies are required for the `auth-operator` and `api-auth` to function correctly.

### Auth Operator

```hcl
path "kv/data/client-credentials/*" {
  capabilities = ["create", "update", "read", "delete"]
}

path "kv/metadata/client-credentials/*" {
  capabilities = ["list", "read", "delete"]
}

path "auth/kubernetes/role/*" {
  capabilities = ["create", "update", "read", "delete"]
}
```

### API Auth

```hcl
path "kv/data/client-credentials/master" {
  capabilities = ["read"]
}
```

## Uninstalling the Chart

To uninstall/delete the `auth-operator` deployment:

```bash
helm uninstall auth-operator
```
