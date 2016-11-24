#!/bin/bash
#
#	grab what we need of a ClientB driveas quickly as possible...
#
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ $# -eq 0 ]; then
   echo "You need to provide a target directory name" 1>&2
   exit 1
fi

if [ $# -gt 1 ]; then
   echo "Provide just ONE directory name" 1>&2
   exit 1
fi
	
echo Setup...
DIR=/media/Elements/MMush/$1
clear
echo
echo Copying key data to $DIR
echo
mkdir $DIR
cd $DIR
fdisk -l -u /dev/sdc >fdisk.txt

echo 
echo Boot sector..
sudo dd if=/dev/sdc of=sdc-boot bs=446 count=1
echo
echo Partition two...
dd if=/dev/sdc2 of=sdc2 bs=32256
echo
echo Partition three...
dd if=/dev/sdc3 of=sdc3 bs=32256
ls -ltr 
cd ..
echo
echo Done!
