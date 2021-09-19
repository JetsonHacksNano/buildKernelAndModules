#!/bin/bash
# Example to build Logitech F710 module on NVIDIA Jetson Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License
# build the hid-logitech.ko module with Logitech F710 support
# We need the kernel sources installed

SOURCE_TARGET="/usr/src/"
KERNEL_RELEASE=$( uname -r | cut -d. -f1-2)
KERNEL_URI=$SOURCE_TARGET"kernel/kernel-"$KERNEL_RELEASE
if [ ! -d "$KERNEL_URI" ] ; then
  echo "Cannot find kernel source in $SOURCE_TARGET."
  echo "You will need to install the kernel source before proceeding."
  exit 1
fi

cd "$KERNEL_URI"

sudo bash scripts/config --file .config \
	--set-val LOGITECH_FF y
sudo make modules_prepare
sudo make drivers/hid/hid-logitech.ko

echo "Build complete."
echo "The module is here: ${KERNEL_URI}/drivers/hid/hid-logitech.ko"
echo "To install the module:"
echo " "

INSTALL_DIRECTORY=/lib/modules/$(uname -r)/kernel/drivers/hid
echo "$ sudo cp -v ${KERNEL_URI}/drivers/hid/hid-logitech.ko $INSTALL_DIRECTORY"
echo "$ sudo depmod -a"

echo ""
echo "You may need to reboot for the changes to take effect."




