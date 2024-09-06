# Packages

Notes from creating a a custom kernel package for the Orange PI 5.

- [Building custom images](https://www.talos.dev/v1.7/advanced/building-images/)
- [Customising the kernel](https://www.talos.dev/v1.7/advanced/customizing-the-kernel/)

```bash
docker buildx prune

cd ~/Projects/forks/pkgs

nix-shell -p gnumake crane dive

git checkout -b feat/kernel-orangepi-5

export TALOS_VERSION=v1.7.6
export DEVICE=orangepi-5

# These are used by the Makefile directly.
export REGISTRY=ghcr.io
export USERNAME=mahdtech
export TAG=${TALOS_VERSION}-${DEVICE}

# Updated the kernel to v6.8.9 to include RK3588s support.
vim Pkgfile

make \
  USERNAME=${USERNAME} \
  kernel-olddefconfig

# Make just the kernel package.
make \
  USERNAME=${USERNAME} \
  REGISTRY=${REGISTRY} \
  TAG=${TALOS_VERSION}-${DEVICE} \
  PLATFORM=linux/amd64,linux/arm64 \
  PUSH=true \
  kernel

# Make all the packages.
make \
  USERNAME=${USERNAME} \
  REGISTRY=${REGISTRY} \
  TAG=${TALOS_VERSION}-${DEVICE} \
  PLATFORM=linux/amd64,linux/arm64 \
  PUSH=true
```
