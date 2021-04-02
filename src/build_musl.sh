#!/bin/sh -ex

EXE=$(realpath $0)

cd $(dirname $0)
BUILD=$(realpath build_dir)/usr/

cd dep/musl/

export CC=clang
export CFLAGS="-march=native -mtune=native -Oz -flto --sysroot ${BUILD} -isystem ${BUILD}/include"
export LDFLAGS='-flto -fuse-ld=lld -Wl,--plugin-opt=O3,-O3,--gc-sections,--icf=safe'

if [ ! -f config.mak ] || [ "$EXE" -nt config.mak ]; then
    rm -f config.mak

    ./configure --prefix=${BUILD} --disable-shared
    # Workaround for lto
    echo 'obj/ldso/dlstart.lo: CFLAGS_ALL += -fno-lto' | tee -a config.mak
fi

make -j $(nproc)
make install

cd ${BUILD}/bin/

sed 's/-print-prog-name=ld/-print-prog-name=ld.lld/' ld.musl-clang >ld.musl-clang-lld
sed 's/-lc/-l:libc.a/' ld.musl-clang-lld >ld.musl-clang-lld-static
chmod +x ld.musl-clang-lld*

ln -sf musl-clang musl-gcc
ln -sf /usr/bin/as musl-as
ln -sf /usr/bin/ar musl-ar
ln -sf /usr/bin/nm musl-nm
ln -sf /usr/bin/strip musl-strip
ln -sf /usr/bin/objcopy musl-objcopy
ln -sf /usr/bin/objdump musl-objdump
ln -sf /usr/bin/pkg-config musl-pkg-config
