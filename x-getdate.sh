#!/bin/bash
#

# IFS business, because we have filenames
# with spaces in them...
OLDIFS=$IFS
IFS=$'\n'

find ClientA-mail-eml/ -type f 	-exec sh -c "head -100 "{}" |grep -i "^date:"|head -1" \;


IFS=$OLDIFS
