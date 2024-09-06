# Overlay

Notes from creating an overlay for the Orange PI 5.

- [Overlays](https://www.talos.dev/v1.7/advanced/overlays/)
- [PR](https://github.com/siderolabs/sbc-rockchip/pull/31)

```bash
docker buildx prune

cd ~/Projects/forks/sbc-rockchip

export TALOS_VERSION=v1.7.6
export DEVICE=orangepi-5

# These are used by the Makefile directly.
export REGISTRY=ghcr.io
export USERNAME=mahdtech
export TAG=${TALOS_VERSION}-${DEVICE}
export IMAGE_TAG=${TALOS_VERSION}-${DEVICE}

# These are used to point to the custom kernel built earlier.
export PKGS_PREFIX=${REGISTRY}/${USERNAME}
export PKGS=${TAG}

make \
  PLATFORM=linux/arm64 \
  DEST=_out \
  local-sbc-rockchip

make \
  PLATFORM=linux/arm64 \
  PUSH=false \
  docker-sbc-rockchip

make \
  PUSH=true \
  all
```

## Debugging

Some notes that were useful when debugging the overlay.

```bash
cd $(mktemp -d)

docker run \
  --rm \
  --name builder \
  -it \
  --mount type=bind,source="$(pwd)"/,target=/workspace \
  --workdir /workspace \
  docker.io/alpine:latest /bin/ash

apk add \
  curl \
  python3 \
  poetry \
  make \
  bash \
  openssl \
  musl \
  musl-dev \
  musl-utils \
  tree \
  bison \
  flex \
  swig \
  python3-dev \
  openssl-dev \
  ossp-uuid-dev \
  vim \
  gnutls-dev \
  libuuid \
  util-linux-dev \
  util-linux-misc \
  build-base

if [[ ! -d .venv ]];
then
  virtualenv -p python3 .venv
fi

source .venv/bin/activate
pip3 install pyelftools setuptools

echo "CREATING DIRECTORIES..."

mkdir archives
mkdir musl-cross
mkdir arm-trusted-firmware
mkdir rkbin
mkdir uboot

echo "DOWNLOADING..."

curl -L https://github.com/ARM-software/arm-trusted-firmware/archive/44418fce30938ee483fbfc79cc32fde33753d1aa.tar.gz -o archives/arm-trusted-firmware.tar.gz
curl -L https://musl.cc/aarch64-linux-musl-cross.tgz -o archives/aarch64-linux-musl-cross.tgz
curl -L https://ftp.denx.de/pub/u-boot/u-boot-2024.10-rc4.tar.bz2 -o archives/u-boot.tar.bz2
curl -L https://github.com/rockchip-linux/rkbin/archive/a2a0b89b6c8c612dca5ed9ed8a68db8a07f68bc0.tar.gz -o archives/rkbin.tar.gz

echo "EXTRACTING..."

tar xzf archives/aarch64-linux-musl-cross.tgz -C musl-cross --strip-components=1
tar xzf archives/arm-trusted-firmware.tar.gz -C arm-trusted-firmware --strip-components=1
tar xzf archives/rkbin.tar.gz -C rkbin --strip-components=1
tar xf archives/u-boot.tar.bz2 -C uboot --strip-components=1

echo "BUILD: ARM TRUSTED FIRMWARE"

export CROSS_COMPILE=/workspace/musl-cross/bin/aarch64-linux-musl-

cd arm-trusted-firmware
make realclean
make PLAT=rk3588 DEBUG=0 bl31
cd -

echo "BUILD: UBOOT"

cd uboot
make orangepi-5-rk3588s_defconfig
make \
  --include-dir=/lib \
  --include-dir=/usr/include \
  --include-dir=/lib/libuuid.so.1 \
  HOSTLDLIBS_mkimage="-lssl -lcrypto" \
        BL31=/workspace/arm-trusted-firmware/build/rk3588/release/bl31/bl31.elf \
        ROCKCHIP_TPL=/workspace/rkbin/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.16.bin \
        CONFIG_USB_HOST_ETHER=y \
        CONFIG_USB_ETHER_RTL8152=y
cd -
```
