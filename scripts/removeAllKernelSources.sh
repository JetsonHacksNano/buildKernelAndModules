#!/bin/bash
# Remove the kernel sources and build remnants from the NVIDIA Developer Kit
# This should reverse getKernelSources.sh
# Copyright (c) 2016-21 Jetsonhacks 
# MIT License

cd ${SOURCE_TARGET}
rm -r kernel
rm -r hardware
rm nvbuild.sh
rm nvcommon_build.sh
rm public_sources.tbz2

