# buildKernelAndModules
Build the Linux Kernel and Modules on board the NVIDIA Jetson Nano Developer Kit

These scripts are for JetPack 4.2.1, L4T 32.2

Scripts to help build the 4.9.140 kernel and modules onboard the Jetson Nano Developer Kit Previous versions may be available in releases.

<em><strong>Note:</strong> The kernel source version must match the version of firmware flashed on the Jetson. For example, the source for the 4.9.140 kernel here is matched with L4T 32.2. This kernel compiled using this source tree may not work with newer versions or older versions of L4T</em>

As of this writing, the "official" way to build the Jetson Nano kernel is to use a cross compiler on a Linux PC. This is an alternative which builds the kernel onboard the Jetson itself. These scripts will download the kernel source to the Jetson Nano, and then compile the kernel and selected modules. The newly compiled kernel can then be installed. We recommend a SD card size of 32GB, 64GB preferred.

The scripts should be run directly after flashing the Jetson, or copying the SD card image from a host PC. There are several scripts:

<strong>getKernelSources.sh</strong>

Downloads the kernel sources for L4T from the NVIDIA website, decompresses them and opens a graphical editor on the .config file. Note that this also sets the .config file to the current system, and also sets the local version to the current local version, i.e., -tegra


<strong>makeKernel.sh</strong>

Compiles the kernel using make. The script commands make the kernel Image file. Installing the Image file on to the system is a separate step. Note that the make is limited to the Image and modules.

The other parts of the kernel build, such as building the device tree, require that the result be 'signed' and flashed from the the NVIDIA tools on a host PC.

<strong>makeKernel.sh</strong>

Compiles the modules using make and then installs them.

<strong>copyImage.sh</strong>

Copies the Image file created by compiling the kernel to the /boot directory. Note that while developing you will want to be more conservative than this: You will probably want to copy the new kernel Image to a different name in the boot directory, and modify /boot/extlinux/extlinux.conf to have entry points at the old image, or the new image. This way, if things go sideways you can still boot the machine using the serial console.

You will want to make a copy of the original Image before the copy, something like:

# Put a copy of the current Image here
$ cp /boot/Image $INSTALL_DIR/Image.orig
$ ./copyImage.sh
$ echo "New Image created and placed in /boot"


<strong>editConfig.sh</strong>
Edit the .config file located in /usr/src/kernel/kernel-4.9 This file must be present (from the getKernelSources.sh script) before launching the file. Note that if you change the local version, you will need to make both the kernel and modules and install them.

<strong>removeAllKernelSources.sh</strong>
Removes all of the kernel sources and compressed source files. You may want to make a backup of the files before deletion.

<h2>Notes:</h2> 
<h3>Make sure to update the micro SD card</h3>

The copyImage.sh script copies the Image to the current device. If you are building the kernel on an external device, for example a USB drive, you will probably want to copy the Image file over to the micro SD card in the micro SD's /boot directory. 
Special thanks to Raffaello Bonghi (https://github.com/rbonghi) for jetson_easy scripts.
Special thanks to Shreeyak (https://github.com/Shreeyak) for discussing alternatives to get source directly from NVIDIA git repositories.
Special thanks to Dustin Franklin (https://github.com/dusty-nv/) for how to correctly determine the correct L4T version. (https://github.com/dusty-nv/jetson-inference/blob/7e81381a96c1ac5f57f1728afbfdec7f1bfeffc2/tools/install-pytorch.sh#L296) 

Sometimes it is useful to log the builds:

$ command 2>&1 | tee log.txt

so you can go back and catch errors.

### Release Notes
July, 2019
* vL4T32.2
* L4T 32.2 (JetPack 4.2.1)
* Initial Release 


command 2>&1 | tee log.txt
