#!/bin/bash
# Builds modules and installs them
# Assumes that the .config file is available in /proc/config.gz
# Added check to see if make builds correctly; retry once if not

echo "Source Target: "$SOURCE_TARGET

MAKE_DIRECTORY="$SOURCE_TARGET"kernel/kernel-4.9

cd "$SOURCE_TARGET"kernel/kernel-4.9
# make prepare
# Get the number of CPUs 
NUM_CPU=$(nproc)

# Make the kernel Image 
time make -j$(($NUM_CPU - 1)) Image
if [ $? -eq 0 ] ; then
  echo "Image make successful"
  echo "Image file is here: "
  echo "$SOURCE_TARGET""kernel/kernel-4.9/arch/arm64/boot/Image"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "Make did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  make Image
  if [ $? -eq 0 ] ; then
    echo "Image make successful"
    echo "Image file is here: "
    echo "$SOURCE_TARGET""kernel/kernel-4.9/arch/arm64/boot/Image"
  else
    # Try to make again
    echo "Make did not successfully build" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi


