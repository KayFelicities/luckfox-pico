#! /bin/bash

cp -a kayPatch/buildroot.config sysdrv/source/buildroot/buildroot-2023.02.6/.config \
&& ( cd /home/kay/workspace/luckfox-pico/sysdrv/source/buildroot/buildroot-2023.02.6 && make menuconfig && make savedefconfig && make ) \
&& cp -a sysdrv/source/buildroot/buildroot-2023.02.6/.config kayPatch/buildroot.config
