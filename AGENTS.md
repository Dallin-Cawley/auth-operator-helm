# Auth Operator Helm Chart - Project Overview

This documentation provides a high-level overview of the `auth-operator-helm` project, its goals, features, and usage instructions for both human users and automated agents.

## Project Goals
The `auth-operator-helm` chart is designed to automate the deployment and management of the `auth-operator` on Kubernetes. Its primary objectives are:
- **Simplified Deployment**: Provide a single Helm chart to deploy the complete authentication infrastructure.
- **Secure Credential Management**: Integrate seamlessly with OpenBao for robust and secure storage of sensitive credentials.
- **Identity Management**: Enable the operator to manage authentication-related resources within a Kubernetes cluster.

## Key Features
- **OpenBao Backend Support**: Native integration with OpenBao as the primary (and currently only) backend store for secrets and transit signing keys.
- **Dual Component Orchestration**: Manages the deployment of both the `auth-operator` (the controller) and `api-auth` (the API service).
- **Flexible Authentication**: Supports multiple authentication methods for OpenBao, including Token-based and Kubernetes Service Account-based authentication.
- **Configurable RBAC**: Offers granular control over Kubernetes permissions through configurable `Role` or `ClusterRole` resources for each component.
- **Proxy-based Auth**: Utilizes an OpenBao proxy to handle complex authentication workflows with the OpenBao server.
- **TLS Configuration**: Supports self-signed certificates and custom CA bundles for secure communication with backend stores.

## Architecture & Components
The Helm chart deploys the following primary components:
1. **Auth Operator**: A Kubernetes operator that watches for custom resources and manages authentication logic.
2. **API Auth**: A service that provides authentication endpoints and interacts with the master secret in OpenBao.
3. **OpenBao Proxy**: Injected as a sidecar to handle the lifecycle of authentication tokens between the components and OpenBao.

## Usage Overview
### Prerequisites
- Kubernetes 1.19+
- Helm 3.2.0+
- An accessible OpenBao instance.

### Installation
To deploy the chart with the default configuration:
```bash
helm install auth-operator .
```

### Configuration Highlights
Configuration is handled via `values.yaml`. Important sections include:
- `store.openbao`: Defines the OpenBao address, mount paths, and authentication roles.
- `kubeAPI`: Controls ServiceAccount creation and RBAC scope.
- `image`: Specifies the container images and tags for the operator and API services.

## Information for Agents
When working with this repository, consider the following:
- **Validation**: Refer to `values.schema.json` for the data structure and constraints of the configuration parameters.
- **Policies**: The `README.md` contains the specific HCL policies required by OpenBao for the operator and API services to function correctly.
- **Templates**: Custom logic for resource generation is located in the `templates/` directory, utilizing standard Helm templating and `_helpers.tpl`.
