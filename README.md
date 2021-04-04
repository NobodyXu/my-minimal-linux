# my-minimal-linux

A runnable linux that have only vmlinuz and initramfs (rootfs is embedded in initramfs)

The minimal kernel config `src/linux-kernel-configs/minimal-intel-kvm` I use still retain full virtio capacity.

It supports almost all virtio devices:

```
CONFIG_BLK_MQ_VIRTIO
CONFIG_NET_9P_VIRTIO
CONFIG_VIRTIO_BLK
CONFIG_SCSI_VIRTIO
CONFIG_VIRTIO_NET
CONFIG_VIRTIO_CONSOLE
CONFIG_HW_RANDOM_VIRTIO
CONFIG_VIRTIO_MENU
CONFIG_VIRTIO_PCI
CONFIG_VIRTIO_BALLOON
CONFIG_VIRTIO_INPUT
CONFIG_VIRTIO_MMIO
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES
```

## How to clone this repository

```
git clone --recurse-submodules https://github.com/NobodyXu/my-minimal-linux
```

## How to build this repository

```
cd src/

# You can use linux-kernel-configs/minimal-intel-kvm here
./build_linux.sh <any kernel config you like>
./build_musl.sh
# You can use busybox-configs/config here
./build_busybox.sh <any busybox config you like>

# You can use init, which is the default implementation here
cp <your init> rootfs/init

# Now busybox and init are installed to rootfs, the initramfs is ready to go
./build_initramfs.sh
```
After finishing the build, try run your kernel using qemu-kvm:

```
# Make sure you are still in the repo/src

cd boot

../run_in_vm.sh vmlinuz-5.11.9 initramfs.img
```
