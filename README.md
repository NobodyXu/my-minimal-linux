# my-minimal-linux

A runnable linux that have only vmlinuz and initramfs (rootfs is embedded in initramfs)

The minimal kernel config `src/linux-kernel-configs/minimal-intel-kvm-with-most-virtio` I use still retain full virtio capacity.

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

Using gcc 10.2.0, I was able to build a xz-compressed kernel that is only 2MB large using this configuration.

There is also `src/linux-kernel-configs/minimal-intel-kvm-no-virtio`, of which .

## How to clone this repository

```
git clone --recurse-submodules https://github.com/NobodyXu/my-minimal-linux
```

## Requirement
 - build-essential
 - gcc >= 9.1
 - clang >= 10
 - cpio for building initramfs
 - rsync for coping data

## How to build this repository

```
cd src/

# You can use linux-kernel-configs/minimal-intel-kvm-with-most-virtio here
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
## Cavert when running with the busybox initramfs

To poweroff, you have to either invoke `/sbin/poweroff -f` or enable 
`CONFIG_POWEROFF_ON_INIT_EXIT` in kernel config and poweroff by simply exiting the shell.
