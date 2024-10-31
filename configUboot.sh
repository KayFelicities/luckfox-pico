#! /bin/bash

(cd sysdrv/source/uboot/u-boot && make menuconfig) \
&& cp -a sysdrv/source/uboot/u-boot/.config sysdrv/source/uboot/u-boot/configs/luckfox_rv1106_uboot_defconfig \
