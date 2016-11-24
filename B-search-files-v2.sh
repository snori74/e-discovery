#/bin/bash
#
# select a series of filetypes from some specified directories
# and copy those that have matchin contents to one output 
# folder - prefixing them with unique number, based on the 
# original file's inode, and logging this number and the original
# file path to a logfile. The logfile is named by the selection
# script, and numbered with the PID of the process that created it.

# v2 - including the OCR scan of PDFs 

#	"include" the definition of the search strings $ss
#	
source  ~/B-search-terms.inc

#	"include" function for searching inside PDFs with OCR
#	
source ~/B-PDF-scan.inc

# echo Here are the search terms:
# echo $ss

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'

# Get to the source directory
cd 
cd ClientA

# Some directories to put the results in:...
#
mkdir -p ../ClientA-results/log
mkdir -p ../ClientA-results/files

for disk in "USB-1" "USB-2" "USB-3" 
do
	folder=$disk
	echo $folder
	
	# Specific files (ie anything NOT email)
	#
	files=$(find $folder -type f ! -iname *.pst )
	for f in $files
	do
	
		# grab the unique inode number, last-modified date and base filename
                # and calculate the md5 hash
                #
                md5hash=$(md5sum $f | cut -f1 -d" ")
                index=$(stat $f | grep Inode | awk '{print $4}')
                date=$(stat $f | grep "Modify:" |awk '{print $2}')
                filename=$(basename $f)  
		
		# echo  - $filename
		# Images we copy across...	
		#
		echo $(file $f|cut -f2- -d:) | grep -iq image
		if [ $? -eq 0 ]
		then	
                        # echo DEBUG 2
			# NOTE: where we copy and the log name need changing!
                        #
                        echo Image: $filename
			cp $f ../ClientA-results/files/$index-$filename
                        echo $date "," $index "," $md5hash "," \"$f\" >> ../ClientA-results/log/run-$$.csv
			#echo $date "," $index "," \"$f\" >> ../ClientA-results/log/run-$$.csv
		else
			# echo DEBUG 3
			# check if it's a PDF...        
	                #	
			echo $(file $f|cut -f2- -d:) | grep -iq PDF
        	        if [ $? -eq 0 ]
                	then    
                        	# echo DEBUG 4
				# call the PDF-scan function $include'd in at the top of the script
                        	#
				PDF-scan $f
				if [ $? -eq 0 ]
                                then
                                        echo Matching PDF: $filename
                                        cp $f ../ClientA-results/files/$index-$filename
                                        echo $date "," $index "," $md5hash "," \"$f\" >> ../ClientA-results/log/run-$$.csv
					# echo $date "," "$index" "," \"$f\" >> ../ClientA-results/log/run-$$.csv
                       		else
					echo Non-matching PDF: $filename  - but no match
				fi
			else
                        	# echo DEBUG 5
				# check for the search strings provided...
				#
				egrep -q -i $ss $f 
				if [ $? -eq 0 ]
				# ...and copy and log if we get a match
				then
					# NOTE: where we copy and the log name need changing!
					#
					echo Matching: $filename
					cp $f ../ClientA-results/files/$index-$filename
					echo $date "," $index "," $md5hash "," \"$f\" >> ../ClientA-results/log/run-$$.csv
					#echo $date "," "$index" "," \"$f\" >> ../ClientA-results/log/run-$$.csv
				else
					echo NO MATCH: $filename
				fi
			fi
		fi
	done
done
ISF=$OLDIFS



