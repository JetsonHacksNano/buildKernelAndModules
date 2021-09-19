#!/bin/bash
# Make the kernel for NVIDIA Developer Kit
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

SOURCE_TARGET="/usr/src"
KERNEL_RELEASE=$( uname -r | cut -d. -f1-2) # e.g. 4.9

function usage
{
    echo "usage: ./makeKernel.sh [[-d directory ]  | [-h]]"
    echo "-d | --directory Directory path to parent of kernel"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )      shift
				SOURCE_TARGET=$1
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

# Check to see if source tree is already installed
PROPOSED_SRC_PATH="$SOURCE_TARGET""kernel/kernel-"$KERNEL_RELEASE
echo "Proposed source path: ""$PROPOSED_SRC_PATH"
if [ ! -d "$PROPOSED_SRC_PATH" ]; then
  tput setaf 1
  echo "==== Cannot find kernel source! =============== "
  tput sgr0
  echo "The kernel source does not appear to be installed at: "
  echo "   ""$PROPOSED_SRC_PATH"
  echo "Unable to start making kernel."
  exit 1
fi

export SOURCE_TARGET
export KERNEL_RELEASE

# E Option carries over environment variables
sudo -E ./scripts/makeKernel.sh
