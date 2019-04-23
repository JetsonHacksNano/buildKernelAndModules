#!/bin/bash
# Copy the kernel image to /boot for NVIDIA Jetson Nano Developer Kit, L4T
# Copyright (c) 2016-19 Jetsonhacks 
# MIT License

SOURCE_TARGET="/usr/src"
BOOT_TARGET="/boot/"
KERNEL_RELEASE="4.9"

function usage
{
    echo "usage: ./makeKernel.sh [[-d directory ]  | [-h]]"
    echo "-d | --directory Directory path to parent of kernel"
    echo "-b | --boot  Directory path to boot"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )      shift
				SOURCE_TARGET=$1
                                ;;
        -b | --boot )           BOOT_TARGET=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

LAST="${SOURCE_TARGET: -1}"
if [ $LAST != '/' ] ; then
   SOURCE_TARGET="$SOURCE_TARGET""/"
fi
LAST="${BOOT_TARGET: -1}"
if [ $LAST != '/' ] ; then
   BOOT_TARGET="$BOOT_TARGET""/"
fi

export SOURCE_TARGET
export BOOT_TARGET
export KERNEL_RELEASE

# E Option carries over environment variables
sudo -E ./scripts/copyImage.sh
