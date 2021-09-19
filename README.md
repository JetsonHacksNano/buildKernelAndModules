## jetson-linux-build
Tools to build the Linux kernel and modules on board Jetson Developer Kits

This is a tool for meant for intermediate+ users. Please read this entire document before proceeding.

This repository contains convenience scripts to:
* Download Kernel and Module sources (**B**oard **S**upport **P**ackage - **BSP**) 
* Edit the kernel configuration
* Build the kernel image
* Build all of the kernel modules
* Copy the Kernel Image to the /boot directory - This may not supported for newer versions of L4T - see below _**copyImage.sh deprecation (mostly)**_ 
* An example to build a single kernel module (most useful)

## Scripts

### getKernelSources.sh

Downloads the kernel sources for L4T from the NVIDIA website and decompresses them into _/usr/src/_ . Note that this also sets the .config file to that of the current system, and sets the LOCALVERSION to the current local version, i.e., **-tegra**

### makeKernel.sh

Please read the notes below about installing the kernel using copyImage.sh. Compiles the kernel using make. The script commands builds the kernel Image file. Installing the Image file on to the system is a separate step. 

This and other parts of the kernel build, such as building the device tree, may require that the result be 'signed' and flashed from the the NVIDIA tools on a host PC.

### makeModules.sh

Compiles all of the the modules on the system using make and then installs them. You more than likely not want to do this. Instead, look at the script **build-module.sh** in the _example_ directory for an outline on how to build a single module.

### copyImage.sh

Please read the notes below under _**Background Notes**_ about installing the kernel image. This script copies the Image file created by compiling the kernel to the _**/boot**_ directory. Note that while developing you will want to be more conservative than this: You will probably want to copy the new kernel Image to a different name in the boot directory, and modify _**/boot/extlinux/extlinux.conf**_ to have entry points at the old image, or the new image. This way, if things go sideways you can still boot the machine using the serial console.

You will want to make a copy of the original Image before the copy, something like:
```
$ cp /boot/Image $INSTALL_DIR/Image.orig
$ ./copyImage.sh
$ echo "New Image created and placed in /boot"
```
### editConfig.sh 
Edit the .config file located in _**/usr/src/kernel/kernel-4.9**_ This file must be present (from the getKernelSources.sh script) before launching the file. Note that if you change the local version, you will need to make both the kernel and modules and install them.

### removeAllKernelSources.sh

Removes all of the kernel sources and compressed source files. You may want to make a backup of the files before deletion.

### Example - build-module.sh
The most likely use for these scripts is to build kernel module(s). In the example folder, there is a script named _**build-module.sh**_
You should open the script, read through it, and modify to meet your needs. The script builds a module for the Logitech F710 game controller. The module name is **hid-logitech.ko**

You will need to know the module flag to use this method, in this case it is: **LOGITECH_FF** 


## Background Notes
Over the years, we have been maintaining several different repositories here and on https://github.com/jetsonhacksnano to build the Linux kernel and modules for the various NVIDIA Jetson models:

* Jetson Nano
* Jetson Nano 2GB
* Jetson TX1
* Jetson TX2
* Jetson AGX Xavier
* Jetson Xavier NX

The main difficulty of this approach is that there are several different repositories to maintain across NVIDIA L4T releases.

There are two different versions of BSP source code for each NVIDIA L4T release. One version is for the Jetson Nano, Nano 2GB and TX1 named **T210**. The other version is for the Jetson TX2, AGX Xavier, and Xavier NX named **T186**. The only difference in building the kernel from machine to machine is where to download the BSP sources from for a given release. The idea of this repository is to place these URLs into an associative array to lookup given the L4T release version.

The other procedures have remained the same over the years, except for placing items in the _**/boot**_ directory. The placement of the Linux kernel image, device tree and extlinux.conf may be different based on the Jetson model and L4T release.

### copyImage.sh deprecation (mostly)
There has been an architectural shift on different Jetson models to provide better security. These changes are implemented differently on each model, depending on hardware capabilities and bootloaders of the Jetson module in question. Several system files, such as but not limited to the Linux kernel and device tree, may now be signed. 

For example, on the Jetson Xaviers the kernel is PKC Signed and has SBK encryption in the newer releases. Currently, the NVIDIA approved application to sign these files is an x86 app running on the host machine.

Additionally, there are Jetsons which place the **/boot** folder into the onboard QSPI-NOR flash memory to be read at boot time, rather than reading it from the **APP** partition. Consequently the developer needs to know where/how to place a newly created kernel and support code. 

The copyImage.sh script may be helpful depending on the Jetson model and L4T release it is being used with. However, on some releases or Jetson models it may not work, or give a false sense of hope of actually doing something. 

### So what good are these scripts?
One thing that the scripts are useful for is building external kernel modules. People can build the modules on the device without having to go through the steps of setting up a development environment on the host, building the module, and transferring it to the Jetson. Instead, build the module on the Jetson and then install it.

## Release Notes

### September, 2021
* Initial Release
* Unification of build methods across Jetson platform
  * Jetson Nano, Nano 2GB, TX1, TX2, AGX Xavier, Xavier NX
* Associative lookup of BSP source code via L4T Release name
* L4T Releases 32.4.2 through 32.6.1
* Tested on Jetson Nano, Jetson Xavier NX
