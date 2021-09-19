#!/bin/bash
# Get the kernel source for NVIDIA Jetson Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

# Install the kernel source for L4T
source scripts/jetson_variables

#Print Jetson version
echo "$JETSON_MACHINE"
#Print Jetpack version
echo "Jetpack $JETSON_JETPACK [L4T $JETSON_L4T]"
SOURCE_TARGET="/usr/src/"
KERNEL_RELEASE=$( uname -r | cut -d. -f1-2) # e.g. 4.9

LAST="${SOURCE_TARGET: -1}"
if [ $LAST != '/' ] ; then
   SOURCE_TARGET="$SOURCE_TARGET""/"
fi

echo "Kernel Release: $KERNEL_RELEASE"
echo "Placing kernel source into $SOURCE_TARGET"

# Check to see if source tree is already installed
PROPOSED_SRC_PATH="$SOURCE_TARGET""kernel/kernel-"$KERNEL_RELEASE
if [ -d "$PROPOSED_SRC_PATH" ]; then
  tput setaf 1
  echo "==== Kernel source appears to already be installed! =============== "
  tput sgr0
  echo "The kernel source appears to already be installed at: "
  echo "   ""$PROPOSED_SRC_PATH"
  echo "If you want to reinstall the source files, first remove the directories: "
  echo "  ""$SOURCE_TARGET""kernel"
  echo "  ""$SOURCE_TARGET""hardware"
  echo "then rerun this script"
  exit 1
fi

export SOURCE_TARGET
export KERNEL_RELEASE

# -E preserves environment variables
sudo -E ./scripts/getKernelSources.sh


