# Orange PI 5

## Table of Contents

- [Orange PI 5](#orange-pi-5)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Steps](#steps)
    - [Packages](#packages)
    - [Talos](#talos)
    - [Overlay](#overlay)
    - [Boot Assets](#boot-assets)
    - [Flash](#flash)

## Overview

My memory is like a fish :fish:

These are the steps to get a Talos image built and working on the Orange PI 5.

## Steps

### Packages

The first part is to make any package modifications.

In this example, a custom kernel package that includes support for the device. Linux v6.8.9 includes support for the Rockchip RK3588s.

- [Notes](./packages.md)

### Talos

Next, build the Talos base artifacts bundling the custom packages.

- [Notes](./base-artifacts.md)

### Overlay

Next, create an overlay for the device that uses the custom kernel package.

- [Notes](./overlay.md)

### Boot Assets

Create the boot assets for the device.

- [Notes](./boot-assets.md)

### Flash

**REMINDER:** _Only the blue USB port works in Maskrom mode._

It's [flashing](http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_5_Plus#How_to_use_RKDevTool_to_burn_Linux_image_into_eMMC) time!

- [Debian SD-Card Images](https://drive.google.com/drive/folders/1KnmBQ3Z0M_5snRC24LjhKb8_tKbcfOkw)

- Download [MiniLoaderAll.bin](https://drive.google.com/drive/folders/19SMZHj1Y8l_Vvr6_SMDHYdJHi41hMgsI)

- Unzip OS img

- Press and hold the MASKROM button, then plug in USB power and release the MASKROM button.

- Plug in front usb-c to computer

- Run the following

```bash
rkdeveloptool db MiniLoaderAll.bin
```

- After _Downloading bootloader succeeded_ run;

```bash
rkdeveloptool wl 0 <os>.img

sudo rkdeveloptool rd
```

- After _Reset Device OK_ unplug the usb-c.

If need, erasing SPI instructions can be found [here](https://docs.radxa.com/en/rock5/rock5c/low-level-dev/maskrom/erase#erase-spi-flash).
