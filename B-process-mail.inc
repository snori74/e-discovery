#!/bin/bash
#
#	B-process-mail.inc
#
#	- function to process a matching mail item component
#	- to be sourced into a main script and called there
#	- copies the file (with index number prefix) into the results 
#	  folder, and creates a log entry. Also copies the 
#	  matching full mail message in .eml form and creates
#	  a suitable log entry for that.
#

function process-mail {
	echo DEBUG01: param1 = $1
	cp $1 ../ClientA-results/mail-files/$index-$filename

	#	Calculate index of the parent item in this split folder, then the 
	#	path to the corresponding full .eml file
	#
	mailmsg=$(basename $1|cut -f1 -d"-")
	echo DEBUG02: mailmsg = $mailmsg
	msgpath=$(dirname $1)
	echo DEBUG03: msgpath = $msgpath
	parentmsg=ClientA-mail-eml/$msgpath/$mailmsg.eml
	pindex=$(stat ../$parentmsg |grep Inode|awk '{print $4}')

	#	Create and write the log entry. For files, the date is not accurate, 
	#	and the From: is not applicable
	#
	date=" "
	from=" "
	echo \"$date\" "," \"$from\" "," $index "," $pindex "," $md5hash "," \"$1\" >> ../ClientA-results/mail-log/run-$$.csv

	#	If the parent file is needed, and we have not already got it - do so. And create a log entry
	#
	if $getparent 
	then
		if [ ! -f ../ClientA-results/mail-files/$pindex-$mailmsg.eml ]
		then
			cp ../$parentmsg ../ClientA-results/mail-files/$pindex-$mailmsg.eml
			index=$pindex
			# the "Date:" might be from another timezone and the format of the "From:"
			# is a bit varied, but they are nevertheless useful...
			date=$(head -50 ../$parentmsg | grep -i "^Date:" | head -1 | awk '{ print $2,$3,$5 }')
			from=$(head -50 ../$parentmsg | grep -i "^From:" | head -1 | cut -f2 -d":")
			echo \"$date\" "," $from "," $index "," $pindex "," $md5hash "," \"$parentmsg\" >> ../ClientA-results/mail-log/run-$$.csv
		fi
	fi
}


