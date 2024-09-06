# Boot Assets

Notes from creating the boot assets for the Orange PI 5.

```bash
cd ~/Projects/forks/talos

nix-shell -p gnumake crane dive

export TALOS_VERSION=v1.7.6
export DEVICE=orangepi-5

# These are used by the Makefile directly.
export REGISTRY=ghcr.io
export USERNAME=mahdtech
export TAG=${TALOS_VERSION}-${DEVICE}

export IMAGER_IMAGE=${REGISTRY}/${USERNAME}/imager:${TAG}
export OVERLAY_IMAGE=${REGISTRY}/${USERNAME}/sbc-rockchip:${TAG}
export OVERLAY_NAME=orangepi-5

# Test building metal image format.
make image-metal

# Finally, build the final image using the overlay.
docker run \
  --name imager \
  --rm \
  -t \
  --env GITHUB_TOKEN \
  --volume /dev:/dev \
  --volume $PWD/_out:/out \
  --privileged \
  ${IMAGER_IMAGE} \
    ${OVERLAY_NAME} \
    --arch arm64 \
    --overlay-image=${OVERLAY_IMAGE} \
    --overlay-name=${OVERLAY_NAME}

tree _out
```
