#!/usr/bin/env bash

# Variables from command line input
MERGED_TAGALIGN_FILE=$1
PEAK_DIR=$2
N=$3

# make sure output PEAK_DIR path ends in slash
if  [[ $PEAK_DIR != */ ]];
then
    PEAK_DIR="${PEAK_DIR}/"
fi

#file with cluster names 
CELLTYPE_FILE="${PEAK_DIR}cluster_barcode_files/UNIQUE_CLUSTERS_LIST.txt"

# read cluster names into array from file
readarray -t celltypes < ${CELLTYPE_FILE}
 


# barcode file directory
BARCODE_FILE_DIR="${PEAK_DIR}cluster_barcode_files/"

# set output directory
OUTDIR="${PEAK_DIR}cluster_split_tagalign_files/"

# check if output directory exists
if [ -d ${OUTDIR} ] 
then
    echo "" 
else
    mkdir ${OUTDIR}
fi




# N=6 # set by command line

for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on    ${cell}       $dt"
    barcodeFile="${BARCODE_FILE_DIR}${cell}.barcodes"
    split_tagalign_file="${OUTDIR}${cell}.tagalign"
    sort_tagalign_file="${OUTDIR}${cell}.sort.tagalign"
    cp_sort_tagalign_file="${OUTDIR}${cell}.sort.tagalign2"
    gzip_copy_file1="${OUTDIR}${cell}.sort.tagalign2.gz"
    gzip_copy_file2="${OUTDIR}${cell}.sort.tagalign.gz"
    
    # split tagalign file
#     zgrep -F -f ${barcodeFile} ${MERGED_TAGALIGN_FILE} > ${split_tagalign_file}  # gives wrong reads, for some reason
    grep -F -f ${barcodeFile} ${MERGED_TAGALIGN_FILE} > ${split_tagalign_file}
    
    # sort split tagalign file
    sort -k1,1 -k2,2n ${split_tagalign_file} > ${sort_tagalign_file}
    
    # copy sorted split tagalign file for zip 
    cp ${sort_tagalign_file} ${cp_sort_tagalign_file}
    
    # zip copied sorted split tagalign file
    gzip ${cp_sort_tagalign_file} 
    
    # change gzip name to correct name
    mv ${gzip_copy_file1} ${gzip_copy_file2}
    
    # rm intermediate file
    rm ${split_tagalign_file}
    
    ) &

done





exit 0
