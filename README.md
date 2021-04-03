# my-minimal-linux

A runnable linux that have only vmlinuz and initramfs (rootfs is embedded in initramfs)

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

./run_in_vm.sh vmlinuz-5.11.9 initramfs.img
```
