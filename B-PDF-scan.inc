#!/bin/bash
#
#	B-PDF-scan.inc
#
#	- function to search inside a PDF
#	- to be sourced into a main script and called
#	- first converts to tiff, then OCRs to text - then searches THAT!
#
# 	(Simplified implementation of http://ubuntuforums.org/showthread.php?t=880471)
#

function PDF-scan {
	DPI=300
	TESS_LANG=eng
	# trim off the .pdf
	FILENAME=$(basename $1 .pdf)
	TMP_DIR="/tmp/pdfcheck/"
	OUTPUT_FILENAME=${FILENAME}
	mkdir -p ${TMP_DIR}
	# cp ${1} ${TMP_DIR}
	# cd ${TMP_DIR}
	# echo $(pwd)
	echo Flattening...
	convert -density ${DPI} -depth 8 ${1} -background white -flatten +matte "${TMP_DIR}${FILENAME}.tif"
	ls -ltr ${TMP_DIR}${FILENAME}.tif
	echo OCRing...
	tesseract "${TMP_DIR}${FILENAME}.tif" "${TMP_DIR}${OUTPUT_FILENAME}" -l ${TESS_LANG}
	ls -ltr ${TMP_DIR}${OUTPUT_FILENAME}.txt 
	# echo Egrepping... 
	egrep -q -i $ss ${TMP_DIR}${OUTPUT_FILENAME}.txt 
	if [ $? -eq 0 ]
		then 
			rm -f ${TMP_DIR}${OUTPUT_FILENAME}.*
			return 0
		else 
			rm -f ${TMP_DIR}${OUTPUT_FILENAME}.*
			return 1
	fi
}


