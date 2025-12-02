# talos-k8s-hcloud

**GitOps-managed Talos Linux + Kubernetes cluster on Hetzner Cloud**

A minimal GitOps-friendly setup for running a Talos Linux Kubernetes cluster on Hetzner Cloud.  
This repository contains Talos machine configurations, cluster manifests, and lightweight tooling to help manage and operate the cluster.

## Why this project

- **Immutable OS for Kubernetes** — Talos Linux is minimal, secure, and API-managed: no SSH, no manual patching, no ad hoc configuration drift.
- **Reproducible infrastructure as code on Hetzner Cloud** — full lifecycle of machines + cluster resources lives in Git. No “snowflake” servers.
- **GitOps-driven cluster operation** — cluster state (node configs, Kubernetes manifests, add-ons) is driven by Git, enabling traceability, rollbacks, and auditability.
- **Best-practice Kubernetes setup** — designed for production-grade deployments, with the ability to extend with networking, storage, backups, metrics, etc.

## What's inside

```
/
├── machineconfigs/   # Talos machine configurations
├── manifests/        # Kubernetes manifests and optional add-ons
├── packer/           # Packer templates to build Talos images
├── tools/            # Small utility scripts used during provisioning and maintenance
├── justfile          # Runs a portable containerized tool environment
├── .sops.yaml        # Secrets encryption config
├── secrets.yaml      # Talos secrets bundle file
├── kubeconfig        # Encrypted kubeconfig for cluster access
├── talosconfig       # Encrypted Talos config for talosctl
└── README.md
```

## `just` — portable tool environment

The `justfile` builds and runs a Docker container that includes:

- `kubectl`
- `talosctl`
- `flux`
- `helm`
- `yq`
- and the required config files (kubeconfig, talosconfig)

This allows you to:

- access and manage the cluster from **any machine**
- avoid manually installing CLI tools locally
- keep your environment consistent and reproducible

### Usage

```bash
# Build and start a container with all required tools installed
just tools
```

Once inside the container you can run commands normally:

```bash
kubectl get nodes
talosctl version
flux get kustomizations
```

## Tools

The `tools/` directory contains small helper scripts used while setting up or maintaining the cluster.

These are intentionally lightweight and optional to simply automate some common steps.

## Secrets

Sensitive data is stored using SOPS with AGE keys.

To edit or decrypt secrets:

```bash
sops --encrypt --in-place --input-type yaml --output-type yaml talosconfig

sops --encrypt --in-place --input-type yaml --output-type yaml kubeconfig

sops --encrypt --in-place somefile.yaml
```

Make sure to decrypt a file before editing it, to avoid conflicts with MAC signature.

```bash
# Default private key location should be:
# $HOME/.config/sops/age/keys.txt
#
# If not set, use SOPS_AGE_KEY_FILE environment variable.
sops --decrypt --in-place --input-type yaml --output-type yaml talosconfig

sops --decrypt --in-place --input-type yaml --output-type yaml kubeconfig

sops --decrypt --in-place somefile.yaml
```

### Key management

- Ensure you have the correct AGE private key available on your workstation.

- Store a second AGE private key inside the cluster as a Kubernetes secret named: `sops-age` into the namespace `flux-system`

## Notes

- kubeconfig and talosconfig are provided for convenience.
  Replace these with your own when deploying your own cluster.

- The repository is intentionally minimal.
  Extend manifests, tooling, and automation as your cluster grows.
