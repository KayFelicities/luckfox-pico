#! /bin/bash

ROOTFS=output/out/rootfs_uclibc_rv1106
USERDATAFS=output/out/userdata


# patch rootfs
cp -a kayPatch/rootfs/* $ROOTFS
chmod +x $ROOTFS/etc/init.d/*

# patch userdata
cp -a kayPatch/userdata/* $USERDATAFS

# create usb gadget image
UMS_BLOCK=output/out/userdata/ums_shared.img
UMS_BLOCK_SIZE=80 #unit M
UMS_BLOCK_TYPE=fat
dd if=/dev/zero of=${UMS_BLOCK} bs=1M count=${UMS_BLOCK_SIZE}
mkfs.${UMS_BLOCK_TYPE} ${UMS_BLOCK}

# build
./build.sh firmware && cp output/image/userdata.img output/image/rootfs.img /mnt/d/hardware/luckfoxPico/images/

# release
mv IMAGE/* /mnt/d/hardware/luckfoxPico/images/
