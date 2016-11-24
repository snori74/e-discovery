#!/bin/bash
#
#	pdf2txt - converts to tiff, thn OCRs to text
#
#
# 	Simplified implementation of http://ubuntuforums.org/showthread.php?t=880471

# 	Might consider doing something with getopts here, see http://wiki.bash-hackers.org/howto/getopts_tutorial
DPI=300
TESS_LANG=eng

FILENAME=${@%.pdf}
SCRIPT_NAME=`basename "$0" .sh`
TMP_DIR=${SCRIPT_NAME}-tmp
OUTPUT_FILENAME=${FILENAME}-output@DPI${DPI}

mkdir ${TMP_DIR}
cp ${@} ${TMP_DIR}
cd ${TMP_DIR}

# convert -density ${DPI} -depth 8 ${@} "${FILENAME}.tif"
#
#	the flatten bit below comes from the answer to:
#	http://stackoverflow.com/questions/5083492/problem-with-tesseract-and-tiff-format
#
convert -density ${DPI} -depth 8 ${@} -background white -flatten +matte "${FILENAME}.tif"
tesseract "${FILENAME}.tif" "${OUTPUT_FILENAME}" -l ${TESS_LANG}

mv ${OUTPUT_FILENAME}.txt ..
rm *
cd ..
# rmdir ${TMP_DIR}

