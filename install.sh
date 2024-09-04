#! /bin/bash
# rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S21appinit  # 这个删除还会重新生成
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S49ntp
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S50telnet
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S91smb
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S99hciinit
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S99luckfoxconfigload
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S99python
rm -f output/out/rootfs_uclibc_rv1106/etc/init.d/S99rtcinit

cp -a kayPatch/S99app output/out/rootfs_uclibc_rv1106/etc/init.d/
cp -a kayPatch/S50usbdevice output/out/rootfs_uclibc_rv1106/etc/init.d/
chmod +x output/out/rootfs_uclibc_rv1106/etc/init.d/*

cp -a kayPatch/app.sh output/out/rootfs_uclibc_rv1106/etc/

cp -a kayPatch/libguiFont.so output/out/rootfs_uclibc_rv1106/lib/
cp -a kayPatch/libcurl.so.4 output/out/rootfs_uclibc_rv1106/lib/

mkdir -p output/out/userdata/apps/
cp -a kayPatch/lcd output/out/userdata/apps/
cp -a kayPatch/reader output/out/userdata/apps/

mkdir -p output/out/userdata/modules/
cp -a kayPatch/soft_uart.ko output/out/userdata/modules/

./build.sh firmware && cp output/image/userdata.img output/image/rootfs.img /mnt/d/hardware/luckfoxPico/images/

mv IMAGE/* /mnt/d/hardware/luckfoxPico/images/
