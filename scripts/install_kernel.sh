#!/bin/bash

#a shell script to install a second kernel to your system when run in the same directory as a kernel tarball as can be retrieved from kernel.org. Usefull for when you are messing with commands that may break your kernel.

echo -n 'searching for linux kernel...'
kernel=$(find -maxdepth 1 -not -type d | grep "linux-" | awk -F '.' '{print "."$2"."$3"."$4}')
echo found kernel $kernel
tar -xf $kernel.tar.xz
cd $kernel/

echo 'install required packages'
sudo apt update
sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev dwarves bc

echo 'configuring the kernel...'
cp /boot/config-$(uname -r) .config
yes "" | make oldconfig
make menuconfig

echo 'compiling the kernel...'
make -j$(nproc)
sudo make modules_install
sudo make install

echo 'adding to grub...'
sudo update-grub
echo 'you should now reboot you system'
