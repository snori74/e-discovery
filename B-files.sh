#/bin/bash
#
# select a series of filetypes from some specified directories
# and copy those that have matchin contents to one output 
# folder - prefixing them with unique number, based on the 
# original file's inode, and logging this number and the original
# file path to a logfile. The logfile is named by the selection
# script, and numbered with the PID of the process that created it.



echo $ss

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'

	folder="ClientA"$disk
	echo $folder
	
	# Specific files
	#
	files=$(find $folder -type f )
	for f in $files
	do
		file $f
	
	done
ISF=$OLDIFS


