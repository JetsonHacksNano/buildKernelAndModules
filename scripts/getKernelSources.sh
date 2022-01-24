#!/bin/bash
# Get the kernel source for NVIDIA Jetson Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

# Table of the URLs to Kernel Sources for Jetson Nano, Nano 2GB and TX1
# L4T Driver Package [BSP] Sources - Code 210
declare -A source_url_list_210=( 
  ["32.6.1"]="https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/sources/t210/public_sources.tbz2"
  ["32.5.2"]="https://developer.nvidia.com/embedded/l4t/r32_release_v5.2/sources/t210/public_sources.tbz2"
  ["32.5.1"]="https://developer.nvidia.com/embedded/l4t/r32_release_v5.1/r32_release_v5.1/sources/t210/public_sources.tbz2"
  ["32.5.0"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v5.0/sources/T210/public_sources.tbz2"
  ["32.4.4"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/Sources/T210/public_sources.tbz2"
  ["32.4.3"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.3/Sources/T210/public_sources.tbz2"
  ["32.4.2"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.2/Sources/T210/public_sources.tbz2" )

# Table of the URLs to Kernel Sources for Jetson TX2, AGX Xavier, Xavier NX
# L4T Driver Package [BSP] Sources - Code 186
declare -A source_url_list_186=( 
  ["32.6.1"]="https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/sources/t186/public_sources.tbz2"
  ["32.5.2"]="https://developer.nvidia.com/embedded/l4t/r32_release_v5.2/sources/t186/public_sources.tbz2"
  ["32.5.1"]="https://developer.nvidia.com/embedded/l4t/r32_release_v5.1/r32_release_v5.1/sources/t186/public_sources.tbz2"
  ["32.5.0"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v5.0/sources/T186/public_sources.tbz2"
  ["32.4.4"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/Sources/T186/public_sources.tbz2"
  ["32.4.3"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.3/Sources/T186/public_sources.tbz2"
  ["32.4.2"]="https://developer.nvidia.com/embedded/L4T/r32_Release_v4.2/Sources/T186/public_sources.tbz2" )

# Get the Board ID ; must be t210ref or t186 ref
BOARD_ID=""
if [ -f /etc/nv_tegra_release ]; then
  # L4T string
  # First line of /etc/nv_tegra_release e.g:
  # - "# R28 (release), REVISION: 2.1, GCID: 11272647, BOARD: t186ref, EABI: aarch64, DATE: Thu May 17 07:29:06 UTC 2018"
  TEGRA_RELEASE=$(head -n 1 /etc/nv_tegra_release)
  BOARD="BOARD: "
  BOARD_ID=${TEGRA_RELEASE##*$BOARD}
  BOARD_ID=${BOARD_ID%%$","*}
else
  # There were a couple of releases where /etc/nv_tegra_release was not present
  # Need to figure it out from the CHIP ID
  case $JETSON_CHIP_ID in
    33 ) # Jetson Nano, Nano 2GB, TX1 ; 0x21
      BOARD_ID="t210ref"
    ;;
    24 ) # Jetson TX2 ; 0x18
      BOARD_ID="t186ref"
    ;;
    25 ) # Jetson Xavier NX, AGX Xavier ; 0x19
      BOARD_ID="t186ref"
    ;;
    *) # Unknown board
      echo "Unrecognized board"
  esac
fi
    
if [ BOARD_ID = "" ] ; then
  echo "Unrecongized board"
  exit 1
fi

SOURCE_URL=""
case ${BOARD_ID} in
   "t186ref" )
     SOURCE_URL=${source_url_list_186[$JETSON_L4T]}
   ;;
   "t210ref" ) 
     SOURCE_URL=${source_url_list_210[$JETSON_L4T]}
   ;;
   *)
    echo "Unrecognized board id: '$BOARD_ID'"
    exit 1
esac

if [ $SOURCE_URL = "" ] ; then
  echo "Unable to find source files on developer.nvidia.com"
  echo "L4T $JETSON_L4T"
  exit 1
fi

apt-add-repository universe
apt-get update
apt-get install pkg-config -y
# We use 'make menuconfig' to edit the .config file; install dependencies
apt-get install libncurses5-dev -y

# A release version is typically something like: 4.9.253-tegra
# We gather the local version (anything after the release numbers, starting with the '-') to
# set the local version for the kernel build process.
KERNEL_VERSION=$(uname -r)
LOCAL_VERSION="-$(echo ${KERNEL_VERSION} | cut -d "-" -f2-)"

# Build the symvers module address
# Example: /usr/src/linux-headers-4.9.253-tegra-ubuntu18.04_aarch64/kernel-4.9/Module.symvers

# Distribution
DISTRIBUTION=$(lsb_release -is)
# Needs to be lower case
DISTRIBUTION="$(echo $DISTRIBUTION | tr '[A-Z]' '[a-z]')"
OS_RELEASE=$(lsb_release -rs)
MODULE_SYMVERS_URL=${SOURCE_TARGET}"linux-headers-"${KERNEL_VERSION}-${DISTRIBUTION}${OS_RELEASE}_$(uname -m)/kernel-${KERNEL_RELEASE}/Module.symvers

echo $MODULE_SYMVERS_URL


cd "$SOURCE_TARGET"
echo "$PWD"
# L4T Driver Package (BSP) Sources
wget -N "$SOURCE_URL"

# l4t-sources is a tbz2 file
tar -xvf public_sources.tbz2  Linux_for_Tegra/source/public/kernel_src.tbz2 --strip-components=3
tar -xvf kernel_src.tbz2
# Space is tight; get rid of the compressed kernel source
rm -r kernel_src.tbz2
cd kernel/kernel-"$KERNEL_RELEASE"
echo "$PWD"

# Copy over the module symbols
# These should be part of the default rootfs
# When the kernel itself is compiled, it should generate its own Module.symvers and place it here
cp "$MODULE_SYMVERS_URL" .
# Go get the current kernel config file; this becomes the base system configuration
zcat /proc/config.gz > .config
# Make a backup of the original configuration
cp .config config.orig
# Default to the current local version
# Should be "-tegra"
bash scripts/config --file .config \
	--set-str LOCALVERSION $LOCAL_VERSION





