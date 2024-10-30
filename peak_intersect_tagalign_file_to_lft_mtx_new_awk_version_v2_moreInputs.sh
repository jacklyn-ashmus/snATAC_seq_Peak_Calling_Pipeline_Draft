#!/usr/bin/env bash

INFILE=$1
CELLTYPE=$2
BARCODE_COL_NUMBER=$3
INFILE_INTERMED_DIR=$4
LFT_UNSORT_DIR=$5
LFT_SORT_DIR=$6

INFILE_INTERMED="${INFILE_INTERMED_DIR}${CELLTYPE}.intersect.lesscol.txt"
INFILE_INTERMED2="${LFT_UNSORT_DIR}${CELLTYPE}.lftmtx.unsort.txt"

# echo "  INFILE_INTERMED = ${INFILE_INTERMED}"
# echo "  INFILE_INTERMED2 = ${INFILE_INTERMED2}"


outfile="${LFT_SORT_DIR}${CELLTYPE}.lftmtx.sort.mtx"

# echo "$BARCODE_COL_NUMBER"

if [ ${BARCODE_COL_NUMBER} == 14 ]
then
# echo " is 14"
awk '{print $1 ":" $2 "-" $3 "\t" $14 }' "${INFILE}" > "${INFILE_INTERMED}"
fi

if [ ${BARCODE_COL_NUMBER} == 7 ]
then
# echo " is 7"
awk '{print $1 ":" $2 "-" $3 "\t" $7 }' "${INFILE}" > "${INFILE_INTERMED}"
fi

# 1         2       3          4                   5      6           7     8       9      10       11     12      13        14                                 
# chr1    9949    10487   CoCl2__acinar_peak_1    122     .       9.43606 15.4437 12.2724 165     chr1    9919    10119   Pool2_CoCl2_PM005_PM008_CCGCACACAAATACCT-1      30      +
    

# if [ -f "$INFILE_INTERMED" ]; then
#     echo "file $INFILE_INTERMED exists."
# else 
#     echo "file $INFILE_INTERMED does not exist."
# fi
    
    

# if [ -d "$LFT_UNSORT_DIR" ]; then
#     echo "directory $LFT_UNSORT_DIR exists."
# else 
#     echo "directory $LFT_UNSORT_DIR does not exist."
# fi
    
    
awk '{
    combination = $1 "\t" $2
    count[combination]++
}
END {
    for (comb in count) {
        print comb, count[comb]
    }
}' "${INFILE_INTERMED}" > "${INFILE_INTERMED2}"

    
sort -k1,1 -k2,2n  "${INFILE_INTERMED2}" > "${outfile}"
