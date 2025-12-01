# talos-k8s-hcloud

**GitOps-managed Talos Linux + Kubernetes cluster on Hetzner Cloud**

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
├── .sops.yaml        # Secrets encryption config
├── secrets.yaml      # Talos secrets bundle file
├── kubeconfig        # Encrypted kubeconfig for cluster access
├── talosconfig       # Encrypted Talos config for talosctl
└── README.md
```
