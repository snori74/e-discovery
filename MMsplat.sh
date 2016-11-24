#!/bin/bash
#
#	plat an ClientB setup onto a drive...
#
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ $# -eq 0 ]; then
   echo "You need to provide a ssource directory name" 1>&2
   exit 1
fi

if [ $# -gt 1 ]; then
   echo "Provide just ONE directory name" 1>&2
   exit 1
fi
	
echo Setup...
DIR=/media/Elements/MMush/$1
clear

cd $DIR

echo 
echo Boot sector..
dd of=/dev/sdc if=sdc-boot bs=446 count=1
echo
echo Partition two...
dd of=/dev/sdc2 if=sdc2 bs=32256
echo
echo Partition three...
dd of=/dev/sdc3 if=sdc3 bs=32256
cd ..
echo
echo Done!
