#/bin/bash
#
# B-therealfinal-email.sh
#
# 	Search the ASCII plaintext and each of the other components of 
#	and email. Log any hits, copyinging the sdocument to the files 
#	directory as normal - but also move the full .eml into files
#
#	The log needs to show the hierchacil relationship (ie this file 
#	is part of email "x".
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

#	some headers for the CSV file...
echo "Unique ID" "," "From: date" "," "File" > ClientA-results/log/email-run-$$.csv

# 	Process each of the .PST files
#	twice, first as .EML type single
#	files, and secondly with all the
#	attachments etc split out.
#
ifile="ClientA/USB-1/PersonA.pst"
ofile1="ClientA-mail/PersonA-emails"
ofile2="ClientA-mail-S/PersonA-emails"
mkdir -p $ofile1
mkdir -p $ofile2
readpst $ifile -o $ofile1  >$ofile1/proc.log
readpst -S $ifile -o $ofile2  >$ofile2/proc.log

ifile="ClientA/USB-1/PersonB.pst"
ofile1="ClientA-mail/PersonB"
ofile2="ClientA-mail-S/PersonB"
mkdir -p $ofile1
mkdir -p $ofile2
readpst $ifile -o $ofile1  >$ofile1/proc.log
readpst -S $ifile -o $ofile2  >$ofile2/proc.log

ifile="ClientA/USB-2/PersonC.pst"
ofile1="ClientA-mail/PersonC"
ofile2="ClientA-mail-S/PersonC"
mkdir -p $ofile1
mkdir -p $ofile2
readpst $ifile -o $ofile1  >$ofile1/proc.log
readpst -S $ifile -o $ofile2  >$ofile2/proc.log

ifile="ClientA/USB-2/PersonD.pst"
ofile1="ClientA-mail/PersonD"
ofile2="ClientA-mail-S/PersonD"
mkdir -p $ofile1
mkdir -p $ofile2
readpst $ifile -o $ofile1  >$ofile1/proc.log
readpst -S $ifile -o $ofile2  >$ofile2/proc.log

ifile="ClientA/USB-3/PersonB/ABC/PersonE/archive.pst"
ofile1="ClientA-mail/archive"
ofile2="ClientA-mail-S/archive"
mkdir -p $ofile1
mkdir -p $ofile2
readpst $ifile -o $ofile1  >$ofile1/proc.log
readpst -S $ifile -o $ofile2  >$ofile2/proc.log
#
#	OK, we now have the mail expanded into both 
# 	ClientA-mail and ClientA-main-S - ready for searching 
#

# DEBUG can out
ISF=$OLDIFS
exit





# The "TRICK" to finding all the main text body of the emails is this:
#
#	find . -regex ".*\/[0-9]{1,4}"
# 


folders=$(find 

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
