#!/bin/bash

# tidy oem
rm -rf $RK_PROJECT_PACKAGE_OEM_DIR/*

# tidy rootfs
# rm $RK_PROJECT_PACKAGE_ROOTFS_DIR/lib/libstdc++.so.6.0.25-gdb.py

rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S21appinit
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S49ntp
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S50telnet
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S91smb
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S99hciinit
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S99luckfoxconfigload
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S99python
rm -f $RK_PROJECT_PACKAGE_ROOTFS_DIR/etc/init.d/S99rtcinit

