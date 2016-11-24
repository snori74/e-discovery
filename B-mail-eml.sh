#/bin/bash
#
# B-mail-eml.sh
#
# 	Simply produce a tree of .eml files from the provided .PSTs
#
#	No good for searching, but these can be read direcetly by Outlook or 
#	Thunderbird, to show the mail in close to its original context



# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'


# 	Process each of the .PST files
#	with the "-M" option to produce
#	single files from each mail message.
#
ifile="ClientA/USB-1/PersonA.pst"
ofile1="ClientA-mail-eml/PersonA-emails"
mkdir -p $ofile1
readpst -M $ifile -o $ofile1  >$ofile1/proc.log

ifile="ClientA/USB-1/PersonB.pst"
ofile1="ClientA-mail-eml/PersonB"
mkdir -p $ofile1
readpst -M $ifile -o $ofile1  >$ofile1/proc.log

ifile="ClientA/USB-2/PersonC.pst"
ofile1="ClientA-mail-eml/PersonC"
mkdir -p $ofile1
readpst -M $ifile -o $ofile1  >$ofile1/proc.log

ifile="ClientA/USB-2/PersonD.pst"
ofile1="ClientA-mail-eml/PersonD"
mkdir -p $ofile1
readpst -M $ifile -o $ofile1  >$ofile1/proc.log

ifile="ClientA/USB-3/PersonB/ABC/PersonE/archive.pst"
ofile1="ClientA-mail-eml/archive"
mkdir -p $ofile1
readpst -M $ifile -o $ofile1  >$ofile1/proc.log

#	Now put an ".eml" extension on each of the files
#	so that they'll open correctly in Windows...
#
cd ClientA-mail-eml
find . -type f -exec mv {} {}.eml \;
cd

ISF=$OLDIFS
exit

