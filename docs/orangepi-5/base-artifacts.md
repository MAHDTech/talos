# Base Artifacts

Notes from building the Talos base artifacts.

- [Developing Talos](https://www.talos.dev/v1.7/advanced/developing-talos/)

```bash
docker buildx prune

cd ~/Projects/forks/talos

nix-shell -p gnumake crane dive

git checkout ${TALOS_VERSION}

export TALOS_VERSION=v1.7.6
export DEVICE=orangepi-5

# These are used by the Makefile directly.
export REGISTRY=ghcr.io
export USERNAME=mahdtech
export TAG=${TALOS_VERSION}-${DEVICE}

make talosctl

# If needed, update the kernel modules to
# loaded into initramfs by editing hack/modules-ARCH.txt
vim hack/modules-ARCH.txt

make \
  PUSH=true \
  installer

make \
  PUSH=true \
  talosctl-image

make \
  PKG_KERNEL=${REGISTRY}/${USERNAME}/kernel:${TAG} \
  INSTALLER_ARCH=all \
  PLATFORM=linux/amd64,linux/arm64 \
  PUSH=true \
  kernel initramfs

make \
  PKG_KERNEL=${REGISTRY}/${USERNAME}/kernel:${TAG} \
  INSTALLER_ARCH=all \
  PLATFORM=linux/amd64,linux/arm64 \
  PUSH=true \
  imager
```
