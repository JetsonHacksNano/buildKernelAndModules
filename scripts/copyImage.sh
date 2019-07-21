#!/bin/bash

echo "Source Target: ""$SOURCE_TARGET"kernel/kernel-$KERNEL_RELEASE/arch/arm64/boot/Image 
echo "Boot Path: ""$BOOT_TARGET"Image

cd "$SOURCE_TARGET"kernel/kernel-$KERNEL_RELEASE
# On the stock Jetson Nano install, there is no zImage in the boot directory
# So we just copy the Image file over
# If the zImage is needed, you must either
# $ make zImage
# or
# $ make
# Both of these commands must be executed in /usr/src/kernel/kernel-4.9
# sudo cp arch/arm64/boot/zImage /boot/zImage
# Note that if you are compiling on an external device, like a SSD, you should
# copy this over to the boot device (i.e SD Card) where the Jetson boots
sudo cp arch/arm64/boot/Image "$BOOT_TARGET"Image


