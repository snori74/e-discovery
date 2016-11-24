#/bin/bash
#
# for each of the PST files create a folder and burst into it 

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'

	
# 
#

ifile="ClientA/USB-1/PersonA.pst"
ofile="ClientA-intermediate/PersonA-emails"
mkdir -p $ofile
readpst -S $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-1/PersonB.pst"
ofile="ClientA-intermediate/PersonB"
mkdir -p $ofile
readpst -S $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-2/PersonC.pst"
ofile="ClientA-intermediate/PersonC-inbox"
mkdir -p $ofile
readpst -S $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-2/PersonD.pst"
ofile="ClientA-intermediate/PersonC-send"
mkdir -p $ofile
readpst -S $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-3/PersonB/ABC/PersonE/archive.pst"
ofile="ClientA-intermediate/ABC-archive"
mkdir -p $ofile
readpst -S $ifile -o $ofile  >$ofile/proc.log

ifile="ClientA/USB-3/PersonB/MTN - CPML/MTN- Archived Emails/archive.pst"
ofile="ClientA-intermediate/MTN-archive"
mkdir -p $ofile
readpst -S $ifile -o $ofile  >$ofile/proc.log


ISF=$OLDIFS


