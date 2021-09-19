#!/bin/bash
# Copy the kernel image on NVIDIA Jetson Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

SOURCE_TARGET="/usr/src/"
KERNEL_RELEASE=$( uname -r | cut -d. -f1-2) # e.g. 4.9
export SOURCE_TARGET
export KERNEL_RELEASE
sudo -E ./scripts/copyImage.sh
