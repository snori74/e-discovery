#!/bin/bash
#
#	B-filetypes.sh
#
#	Enumerate all the filetypes we have to deal with, based on the 
#	standard Windows file extensions.
#
#	Looks in the raw files provided and the files expanded from the .PST files
#

echo > ClientA-results/File-extensions.txt
echo This is a listing of the various file extensions found in the data folders >> ClientA-results/File-extensions.txt
echo and in the parts of emails. >> ClientA-results/File-extensions.txt
echo >> ClientA-results/File-extensions.txt

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'
tmp="/tmp"

echo Filetypes in the raw data provided >> ClientA-results/File-extensions.txt
echo ================================== >> ClientA-results/File-extensions.txt
files=$(find ClientA/ -type f -regextype posix-extended -regex  ".*\.[a-zA-Z]{3,4}$" )
for f in $files
        do
	# echo $f 
	nme=$(basename $f)
	extn=${nme##*.}
	echo $extn >>$tmp/$$-extn
	done
cat $tmp/$$-extn|sort|uniq -c|sort -n >> ClientA-results/File-extensions.txt
rm $tmp/$$-extn

echo >> ClientA-results/File-extensions.txt
echo Filetypes in the expanded mail .PST data provided >> ClientA-results/File-extensions.txt
echo ================================================= >> ClientA-results/File-extensions.txt
files=$(find ClientA-intermediate/ -type f -regextype posix-extended -regex  ".*\.[a-zA-Z]{3,4}$" )
for f in $files
        do
	# echo $f 
	nme=$(basename $f)
	extn=${nme##*.}
	echo $extn >> $tmp/$$-extn
	done
cat $tmp/$$-extn|sort|uniq -c|sort -n >> ClientA-results/File-extensions.txt
rm $tmp/$$-extn

IFS=$OLDFS
