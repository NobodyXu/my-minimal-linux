# my-minimal-linux

A runnable linux that have only vmlinuz and initramfs (rootfs is embedded in initramfs)

## How to clone this repository

```
git clone --recurse-submodules https://github.com/NobodyXu/my-minimal-linux
```

## How to build this repository

```
cd src/

./build_linux.sh linux-kernel-configs/<any config you like>
./build_musl.sh
./build_busybox.sh busybox-configs/<any config you like>
```

where `linux-kernel-configs/<any config you like>` and `busybox-configs/<any config you like>` can 
be replaced with any custom configuration file for linux kernel and busybox respectively.

After the build, busybox will be installed to `rootfs`.
