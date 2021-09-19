#!/bin/bash
# Remove the kernel sources and build remnants from the NVIDIA Developer Kit
# This should reverse getKernelSources.sh
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

# Remove all of the kernel sources that were downloaded and built during the kernel build process
# Note that this will also remove the possibly changed .config file in:
# /usr/src/kernel/kernel-4.9

SOURCE_TARGET="/usr/src/"
KERNEL_RELEASE=$( uname -r | cut -d. -f1-2) # e.g. 4.9

echo "Removing All Kernel Sources"
export SOURCE_TARGET
export KERNEL_RELEASE
sudo -E ./scripts/removeAllKernelSources.sh
echo "Kernel sources removed"
