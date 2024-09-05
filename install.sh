#! /bin/bash

ROOTFS=output/out/rootfs_uclibc_rv1106

# init.d
# rm -f $ROOTFS/etc/init.d/S21appinit  # 这个删除还会重新生成
rm -f $ROOTFS/etc/init.d/S49ntp
rm -f $ROOTFS/etc/init.d/S50telnet
rm -f $ROOTFS/etc/init.d/S91smb
rm -f $ROOTFS/etc/init.d/S99hciinit
rm -f $ROOTFS/etc/init.d/S99luckfoxconfigload
rm -f $ROOTFS/etc/init.d/S99python
rm -f $ROOTFS/etc/init.d/S99rtcinit
cp -a kayPatch/S99app $ROOTFS/etc/init.d/
cp -a kayPatch/S50usbdevice $ROOTFS/etc/init.d/
chmod +x $ROOTFS/etc/init.d/*

# dhcpd
mkdir -p $ROOTFS/etc/dhcp/
cp -a kayPatch/dhcpd.conf $ROOTFS/etc/dhcp/dhcpd.conf

# mosquitto
mkdir -p $ROOTFS/etc/mosquitto/
cp -a kayPatch/mosquitto.conf $ROOTFS/etc/mosquitto/mosquitto.conf

# app
cp -a kayPatch/app.sh $ROOTFS/etc/

cp -a kayPatch/libguiFont.so $ROOTFS/lib/
cp -a kayPatch/libcurl.so.4 $ROOTFS/lib/

mkdir -p output/out/userdata/apps/
cp -a kayPatch/lcd output/out/userdata/apps/
cp -a kayPatch/reader output/out/userdata/apps/

mkdir -p output/out/userdata/modules/
cp -a kayPatch/soft_uart.ko output/out/userdata/modules/

# usb gadget
UMS_BLOCK=output/out/userdata/ums_shared.img
UMS_BLOCK_SIZE=1024 #unit M
UMS_BLOCK_TYPE=fat
dd if=/dev/zero of=${UMS_BLOCK} bs=1M count=${UMS_BLOCK_SIZE}
mkfs.${UMS_BLOCK_TYPE} ${UMS_BLOCK}

# build
./build.sh firmware && cp output/image/userdata.img output/image/rootfs.img /mnt/d/hardware/luckfoxPico/images/

# release
mv IMAGE/* /mnt/d/hardware/luckfoxPico/images/
