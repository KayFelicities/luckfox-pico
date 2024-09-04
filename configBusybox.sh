#! /bin/bash

cp -a kayPatch/busybox.config sysdrv/source/buildroot/buildroot-2023.02.6/output/build/busybox-1.36.1/.config \
&& (cd sysdrv/source/buildroot/buildroot-2023.02.6/output/build/busybox-1.36.1 && make menuconfig) \
&& cp -a sysdrv/source/buildroot/buildroot-2023.02.6/output/build/busybox-1.36.1/.config kayPatch/busybox.config
