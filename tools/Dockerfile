# This file is responsible to setup a toolset to containerize the work environment.
FROM debian:bookworm-slim@sha256:d5d3f9c23164ea16f31852f95bd5959aad1c5e854332fe00f7b3a20fcc9f635c AS installer

# Binaries version
ARG KUBECTL_VERSION=v1.34.1
ARG TALOSCTL_VERSION=v1.11.5
ARG YQ_VERSION=v4.49.2
ARG SOPS_VERSION=v3.11.0
ARG FLUX_VERSION=2.7.3
ARG HELM_VERSION=v3.19.0

# Install curl and CA certificates, so we can access GitHub over HTTPS.
RUN apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && apt-get clean

# Make a /tools directory to copy everything over.
RUN mkdir -p /tools
WORKDIR /tools

RUN curl -L -o kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod u+x kubectl

RUN curl -L -o talosctl https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-amd64 \
    && chmod u+x talosctl

RUN curl -L -o yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    && chmod u+x yq

RUN curl -L -o sops https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 \
    && chmod u+x sops

RUN curl -L -o flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz \
    && tar -xf flux.tar.gz \
    && rm flux.tar.gz \
    && chmod u+x flux

RUN curl -L -o helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm.tar.gz \
    && rm helm.tar.gz \
    && mv linux-amd64/helm helm \
    && chmod u+x helm

# ===========================================================================
# The stage is set up with the right tools, so it's ready as the default 
# non-root Linux user. This avoids ownership problems when mounting 
# our working directory.
FROM debian:bookworm-slim AS workspace
ENV EDITOR=vim

# Install vim for editing
RUN apt-get update \
    && apt-get -y install --no-install-recommends $EDITOR \
    && apt-get clean

# Create group and user.
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} user
RUN useradd -m -s /bin/bash -u ${UID} -g ${GID} user

# The repository will be mounted in /data.
RUN mkdir /data && chown user:user /data
RUN mkdir -p /home/user/.config/helm && chown 1000:1000 /home/user/.config/helm
WORKDIR /data

# Copy all the tools from our installer stage.
COPY --chown=user:user --from=installer /tools/* /usr/local/bin/

# Copy in our entrypoint which is used for setting up the environment.
COPY --chown=user:user --chmod=0700 entrypoint.sh /usr/bin/local/entrypoint

USER ${UID}
ENTRYPOINT ["/usr/bin/local/entrypoint"]
