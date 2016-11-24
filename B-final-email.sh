#/bin/bash
#
# B-sample-email.sh - Search through just the ASCII plaintext of the emails
#			creating a nice spreadsheet of the findings
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
	files=$(find ClientA-intermediate/$folder -type f )
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
