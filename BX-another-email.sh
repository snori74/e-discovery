#/bin/bash
#
# 	Xperimental!!
#
#
# for each of the PST files create a folder and burst into it 
# - BUT using the "-o" to get tthunderbird compatible files
#

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'

	
# 
#

ifile="ClientA/USB-1/PersonA.pst"
ofile="ClientA-X/PersonA-emails"
mkdir $ofile
readpst  $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-1/PersonB.pst"
ofile="ClientA-X/PersonB"
mkdir $ofile
readpst  $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-2/PersonC.pst"
ofile="ClientA-X/PersonC-inbox"
mkdir $ofile
readpst  $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-2/PersonD.pst"
ofile="ClientA-X/PersonC-send"
mkdir $ofile
readpst  $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-3/PersonB/ABC/PersonE/archive.pst"
ofile="ClientA-X/ABC-archive"
mkdir $ofile
readpst  $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-3/PersonB/MTN - CPML/MTN- Archived Emails/archive.pst"
ofile="ClientA-X/MTN-archive"
mkdir $ofile
readpst  $ifile -o $ofile  >$ofile/proc.log


ISF=$OLDIFS


