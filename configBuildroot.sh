#! /bin/bash

cp -a kayPatch/buildroot.config sysdrv/source/buildroot/buildroot-2023.02.6/.config \
&& ./build.sh buildrootconfig \
&& cp -a sysdrv/source/buildroot/buildroot-2023.02.6/.config kayPatch/buildroot.config
