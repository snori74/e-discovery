#!/bin/bash
#
#	B-search-pdf.sh - search inside a PDF
#
#	 - first convert to tiff, then OCRs to text - then search THAT!
#	 - designed to be called from a master script
#
# 	(Simplified implementation of http://ubuntuforums.org/showthread.php?t=880471)
# 	(consider improving witgh getopts here, see http://wiki.bash-hackers.org/howto/getopts_tutorial)

# search strings
#
# search strings
#
ss="submarine|"
ss=$ss"bomb|"
ss=$ss"guilty|"
s=$ss"reamer"

DPI=300
TESS_LANG=eng
FILENAME=${@%.pdf}
SCRIPT_NAME=`basename "$0" .sh`
TMP_DIR="/tmp/pdfcheck"
OUTPUT_FILENAME=${FILENAME}-output@DPI${DPI}

mkdir -p ${TMP_DIR}
cp ${@} ${TMP_DIR}
cd ${TMP_DIR}

# convert -density ${DPI} -depth 8 ${@} "${FILENAME}.tif"
#
#	the flatten bit below comes from the answer to:
#	http://stackoverflow.com/questions/5083492/problem-with-tesseract-and-tiff-format
#
echo Flattening...
convert -density ${DPI} -depth 8 ${@} -background white -flatten +matte "${FILENAME}.tif"
echo OCRing...
tesseract "${FILENAME}.tif" "${OUTPUT_FILENAME}" -l ${TESS_LANG}
#
#  - resulting in OUTPUT_FILENAME.txt, which we then check for out favoorite phrases...
echo Egrepping... $(pwd)
egrep -q -i "water" ${OUTPUT_FILENAME}.txt 
if [ $? -eq 0 ]
	then 
		echo "found!"
	else 
		echo "NOT found !"
fi

