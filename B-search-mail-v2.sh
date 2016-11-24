#!/bin/bash

#
#
#	B-search-mail-v2.sh
#
#	This v2 is a bit smarter:
#	 (1) - skipping the file if a previous run has found it (we don't blow away old runs)
#	 (1) - only doing a full-on OCR of PDF files if a simple string scan hasn't matched   
#		
# 	Search the ASCII plaintext and each of the other components of 
#	all email. Log any hits, copying the matching document to a
#	directory as normal - but also copy the full .eml 
#
#	The log shows the link between component and parent email item
#	by means of the pindex ((Indext # of the parent) column.
#
#	Expects:
#	: - split (readpst -s) mail in ./ClientA-mail-S
#	 - full (readpst -M) mail in ./ClientA-mail-eml
#
#

source B-search-terms.inc
source B-PDF-scan.inc
source B-process-mail.inc

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

cd ClientA-mail-S

for folder in "PersonA-emails"   "PersonB"  "PersonC" "PersonD" "archive"
do
	echo $folder
	
	files=$(find $folder -type f )
	for f in $files
	do
		# grab key info, and calculate the md5 hash
                md5hash=$(md5sum $f | cut -f1 -d" ")
                index=$(stat $f | grep Inode | awk '{print $4}')
                filename=$(basename $f)  

		# only bother if we don't already have the file from an earlier run
		if [ ! -f ../ClientA-results/mail-files/$index-$filename ]
		then 
			# Is this an image?	
			echo $(file $f|cut -f2- -d:) | grep -iq image
			if [ $? -eq 0 ]
			then	
        	                getparent=false
				process-mail $f 
			else
				# Is this a PDF?        
		                #	
				echo $(file $f|cut -f2- -d:) | grep -iq PDF
        		        if [ $? -eq 0 ]
        	        	then    
					# try a simple scan of strings first...
					strings $f | egrep -q -i $ss 
					if [ $? -eq 0 ]
						then
							echo Matching PDF strings: $filename
							getparent=true
							process-mail $f
						else
							# call the PDF-scan function sourced in earlier
							PDF-scan $f
							if [ $? -eq 0 ]
        	                        		then
        	                                		echo Matching PDF: $filename
        	                                		getparent=true
								process-mail $f
        	               				else
								echo Non-matching PDF: $filename  
							fi
					fi
				else
					# proc.log files are not mail components
					if [ ! "$filename" = "proc.log" ]
					then
						egrep -q -i $ss $f 
						if [ $? -eq 0 ]
						then
							echo Matching: $filename
							getparent=true
							process-mail $f
						else
							echo NO MATCH: $filename
						fi
					fi
	
				fi
			fi
		else
			echo Already have: $filename
		fi
	done
done
ISF=$OLDIFS
