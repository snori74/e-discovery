#!/bin/bash

#
#
#	B-search-mail-v3.sh
#
#	Search through the .eml files this time, and check whether it's
#	represented in the selected files, in which case we pull out all 
#	stuff we need and create a log entry - with the CORRECT date this time...

source B-half-process-mail.inc

# IFS trick because some filenames have spaces
OLDIFS=$IFS
IFS=$'\n'

# create needed directories for the results...
mkdir -p ClientA-results/mail-files
mkdir -p ClientA-results/mail-log

#	some headers for the CSV file...
echo 	"Date:" "," \
	"From:"  "," \
	"Unique ID" "," \
	"ID of parent" "," \
	"MD5 hash" "," \
	"File" \
	> ClientA-results/mail-log/run-$$.csv

#	the .eml files this time, rather than the split-out mail
cd ClientA-mail-eml

for folder in "PersonA-emails"   "PersonB"  "PersonC" "PersonD" "archive"
do
	files=$(find $folder -type f )
	for f in $files
	do
		# grab key info...
                index=$(stat $f | grep Inode | awk '{print $4}')
                filename=$(basename $f)  
		# only bother if we DO have the file from an earlier run
		if [  -f ../ClientA-results/mail-files/$index-$filename ]
		then 
                	# saves some time to only calc this here, once we're sure we need it...
			md5hash=$(md5sum $f | cut -f1 -d" ")
			half-process-mail $f
		fi
	done
done
ISF=$OLDIFS
