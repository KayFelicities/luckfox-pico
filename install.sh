#! /bin/bash

ROOTFS=output/out/rootfs_uclibc_rv1106
USERDATAFS=output/out/userdata

# init.d
# rm -f $ROOTFS/etc/init.d/S21appinit  # 这个删除还会重新生成
rm -f $ROOTFS/etc/init.d/S49ntp
rm -f $ROOTFS/etc/init.d/S50telnet
rm -f $ROOTFS/etc/init.d/S91smb
rm -f $ROOTFS/etc/init.d/S99hciinit
rm -f $ROOTFS/etc/init.d/S99luckfoxconfigload
rm -f $ROOTFS/etc/init.d/S99python
rm -f $ROOTFS/etc/init.d/S99rtcinit

# patch rootfs
cp -a kayPatch/rootfs/* $ROOTFS
chmod +x $ROOTFS/etc/init.d/*

# patch userdata
cp -a kayPatch/userdata/* $USERDATAFS

# create usb gadget image
UMS_BLOCK=output/out/userdata/ums_shared.img
UMS_BLOCK_SIZE=1024 #unit M
UMS_BLOCK_TYPE=fat
dd if=/dev/zero of=${UMS_BLOCK} bs=1M count=${UMS_BLOCK_SIZE}
mkfs.${UMS_BLOCK_TYPE} ${UMS_BLOCK}

# build
./build.sh firmware && cp output/image/userdata.img output/image/rootfs.img /mnt/d/hardware/luckfoxPico/images/

# release
mv IMAGE/* /mnt/d/hardware/luckfoxPico/images/
