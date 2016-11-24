#!/bin/bash
#
#	B-half-process-mail.inc
#
#	- function to process a matching mail item component
#	- to be sourced into a main script and called there
#	- copies the file (with index number prefix) into the results 
#	  folder, and creates a log entry. Also copies the 
#	  matching full mail message in .eml form and creates
#	  a suitable log entry for that.
#

function half-process-mail {
	mailmsg=$(basename $1)
	msgpath=$(dirname $1)
	parentmsg=ClientA-mail-eml/$msgpath/$mailmsg
	pindex=$(stat ../$parentmsg |grep Inode|awk '{print $4}')
	index=$pindex
	# the "Date:" might be from another timezone and the format of the "From:"
	# is a bit varied, but they are nevertheless useful...
	date=$(head -50 ../$parentmsg | grep -i "^Date:" | head -1 | awk '{ print $3,$4,$5 }')
	from=$(head -50 ../$parentmsg | grep -i "^From:" | head -1 | cut -f2 -d":")
	echo \"$date\" "," $from "," $index "," $pindex "," $md5hash "," \"$parentmsg\"  >> ../ClientA-results/mail-log/run-$$.csv
}


