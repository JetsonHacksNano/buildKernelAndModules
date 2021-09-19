#!/bin/bash
# Builds modules and installs them
# Assumes that the .config file is available in /proc/config.gz
# Added check to see if make builds correctly; retry once if not

echo "Source Target: "$SOURCE_TARGET

cd $SOURCE_TARGET"kernel/kernel-"$KERNEL_RELEASE

# Get the number of CPUs 
NUM_CPU=$(nproc)

# Make the kernel Image 
time make -j$(($NUM_CPU - 1)) modules
if [ $? -eq 0 ] ; then
  echo "Modules make successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "Make did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  make modules
  if [ $? -eq 0 ] ; then
    echo "Module make successful"
  else
    # Try to make again
    echo "Make did not successfully build modules" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi

make modules_install


