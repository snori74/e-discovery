#/bin/bash
#
# select a series of filetypes from some specified directories
# and copy those that have matchin contents to one output 
# folder - prefixing them with unique number, based on the 
# original file's inode, and logging this number and the original
# file path to a logfile. The logfile is named by the selection
# script, and numbered with the PID of the process that created it.



#	"include" the definition of the search strings $ss
#	
source B-search-terms.inc

#	"include" function for searching inside PDFs with OCR
#	
source B-PDF-scan.inc

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

# and headers for log...
#
echo "Date, Index, Hash, Full path" > ../ClientA-results/log/run-$$.csv
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
	
		# Images we copy across...	
		#
		echo $(file $f|cut -f2- -d:) | grep -iq image
		if [ $? -eq 0 ]
		then	
                        # NOTE: where we copy and the log name need changing!
                        #
                        echo Image: $filename
			cp $f ../ClientA-results/files/$index-$filename
			# echo $date "," $index "," \"$f\" >> ../ClientA-results/log/run-$$.csv
                        echo $date "," $index "," $md5hash "," \"$f\" >> ../ClientA-results/log/run-$$.csv 
		else
			# check if it's a PDF...        
	                #	
			echo $(file $f|cut -f2- -d:) | grep -iq PDF
        	        if [ $? -eq 0 ]
                	then    
                        	#
				# insert a test for matching content later
				# but for now we snaffle them all...
				#
				echo PDF: $filename
                        	cp $f ../ClientA-results/files/$index-$filename
				echo $date "," $index "," $md5hash "," \"$f\" >> ../ClientA-results/log/run-$$.csv
				# echo $date "," $index "," \"$f\" >>../ClientA-results/log/run-$$.csv
                       	else
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
					#echo $date "," "$index" "," \"$f\" >> ../ClientA-results/log/run-$$.csv
					echo $date "," $index "," $md5hash "," \"$f\" >> ../ClientA-results/log/run-$$.csv
				fi
			fi
		fi
	done
done
ISF=$OLDIFS


