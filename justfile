# Builds a "tools" container with most of the tools required
# to interact with the cluster, both Talos itself and Kubernetes.
# Make sure your age key is located in '$HOME/.config/sops/age/keys.txt'.

@build:
    docker build -t tools:latest tools/

# Run the container, mounting in our SOPS and AGE identities.
@tools:
    docker run -it --rm                                 \
    -v $(pwd):/data                                     \
    -v /run/user/1000/:/run/user/1000/:ro               \
    -v $HOME/.age:/home/user/.age:ro                    \
    -v $HOME/.config/sops:/home/user/.config/sops:ro    \
    tools:latest || true
