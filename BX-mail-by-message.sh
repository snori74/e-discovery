#/bin/bash
#
# BX-mail-by-message
#	
#	Take the mail message files (always a simple interger like 34) and process 
#	them and their other components such as rtf and attachments in turn. If only the root
#	mail plantext matches, them only it needs to be included in the results - but if any	
#	attachment matches them both it and the root email need to be included - but in such
#	a way that relationship is clear. 
#
#	Some, such as .rtf, can be scanned by simple grep, others by using 'strings' first
# 	and images can be fed through OCR first.
#
#	Not also that some attachments files are themselves .zip containers - the contents 
#	of which need to be proceessed in a similar fashion.
#
#
#



# search strings
#
ss="submarine|"
ss=$ss"bomb|"
ss=$ss"guilty|"
s=$ss"reamer"

echo $ss

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'
# created needed directories...
mkdir ClientA-results/mail
mkdir ClientA-results/log

echo "Unique ID" "," "From: date" "," "File" > ClientA-results/log/email-run-$$.csv

for folder in "PersonA-emails"  "ABC-archive"  "PersonB"  "MTN-archive"  "PersonC-inbox"  "PersonC-send"
do
	echo Processing $folder ...
	files=$(find ClientA-results/$folder -type f )
	for f in $files
	do
		file $f |grep ASCII 
		if [ $? -eq 0 ]
		then
			egrep -q -i $ss $f
			if [ $? -eq 0 ]
			then
				index=$(stat $f |grep Inode|awk '{print $4}')
				filename=$(basename $f)		
				
				# copy into the mail folder, with the index number, and append .eml 
				# so that they're easily opened in Outlook...
				#
				cp $f ClientA-results/mail/$index-$filename.eml
				
				# and grab the "From:" date from our spreadsheet	
				fromdate=$(head -20 $f |grep -i ^date:|cut -f 2 -d,|cut -f1-4 -d" ")

			echo "$index" "," "$fromdate" "," $f >> ClientA-results/log/email-run-$$.csv
			fi		
		fi
	done
done
ISF=$OLDIFS
