#!/usr/bin/env bash

# Variables from command line input
INPUT_TAGALIGN=$1
OUTPUT_TAGALIGN=$2
BARCODE_LIST_FILE=$3
INTERMEDIATE_DIRECTORY=$4

    dt=$(date '+%d/%m/%Y %H:%M:%S');

    echo "       input = ${INPUT_TAGALIGN}   ${dt}"
    echo "       output = ${OUTPUT_TAGALIGN}   ${dt}"
    echo "       barlist = ${BARCODE_LIST_FILE}   ${dt}"
    echo "       intermed dir = ${INTERMEDIATE_DIRECTORY}   ${dt}"


    split_tagalign_file="${INTERMEDIATE_DIRECTORY}${cell}.splitInit.tagalign"
    cp_sort_tagalign_file="${INTERMEDIATE_DIRECTORY}${cell}.sort.tagalign2"
    gzip_copy_file1="${INTERMEDIATE_DIRECTORY}${cell}.sort.tagalign2.gz"
    gzip_copy_file2="${OUTPUT_TAGALIGN}${cell}.tagalign.gz"


    
    # split tagalign file
#     zgrep -F -f ${barcodeFile} ${MERGED_TAGALIGN_FILE} > ${split_tagalign_file}  # gives wrong reads, for some reason
    grep -F -f ${BARCODE_LIST_FILE} ${INPUT_TAGALIGN} > ${split_tagalign_file}
    
    # sort split tagalign file
    sort -k1,1 -k2,2n ${split_tagalign_file} > ${OUTPUT_TAGALIGN}
    
    # # copy sorted split tagalign file for zip 
    # cp ${OUTPUT_TAGALIGN} ${cp_sort_tagalign_file}
    
    # # zip copied sorted split tagalign file
    # gzip ${cp_sort_tagalign_file} 
    
    # # change gzip name to correct name
    # mv ${gzip_copy_file1} ${gzip_copy_file2}
    
    # # rm intermediate file
    # rm ${split_tagalign_file}

    ) &

done





exit 0
