#!/usr/bin/env bash

CELLTYPE_FILE=$1
TAGALIGN_DIR=$2
TAGALIGN_SUFFIX=$3
PEAK_DIR=$4 # celltype indiv peak files 
PEAK_FILE_SUFFIX=$5 # .fixed_peaks.400bp.bed
BARE_PEAK_FILE_INFIX=$6
OUTPUT_DIR=$7
N=$8


LFT_2_MM_SCRIPT=/nfs/lab/jnewsome/scripts/multiome_CoCl2/peakCalls/lft_mtx_2_sparseMatrix.R

# make sure output PEAK_DIR path ends in slash
if  [[ $OUTPUT_DIR != */ ]];
then
    OUTPUT_DIR="${OUTPUT_DIR}/"
fi

# read cluster names into array from file
readarray -t celltypes < ${CELLTYPE_FILE}



# check if output directory exists
if [ -d ${OUTPUT_DIR} ] 
then
    echo "" 
else
    mkdir ${OUTPUT_DIR}
fi



bare_peak_DIR="${OUTPUT_DIR}bare_peaks/"
if [ -d ${bare_peak_DIR} ] 
then
    echo "" 
else
    mkdir ${bare_peak_DIR}
fi


intersect_DIR="${OUTPUT_DIR}intersect/"
if [ -d ${intersect_DIR} ] 
then
    echo "" 
else
    mkdir ${intersect_DIR}
fi

intersect_lessCol_DIR="${OUTPUT_DIR}intermed_intersect_lessCol/"
if [ -d ${intersect_lessCol_DIR} ] 
then
    echo "" 
else
    mkdir ${intersect_lessCol_DIR}
fi





lft_mtx_unsort_dir="${OUTPUT_DIR}intermed_lft_mtx_unsort/"
if [ -d ${lft_mtx_unsort_dir} ] 
then
    echo "" 
else
    mkdir ${lft_mtx_unsort_dir}
fi




lft_mtx_sort_dir="${OUTPUT_DIR}lft_mtx/"
if [ -d ${lft_mtx_sort_dir} ] 
then
    echo "" 
else
    mkdir ${lft_mtx_sort_dir}
fi



mm_dir="${OUTPUT_DIR}mm/"
if [ -d ${mm_dir} ] 
then
    echo "" 
else
    mkdir ${mm_dir}
fi



echo "##################### make bare peak files ###############################"

for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on intersect   ${cell}       $dt"
    peakfile="${PEAK_DIR}${cell}${PEAK_FILE_SUFFIX}"
    barepeakfile="${bare_peak_DIR}${cell}${BARE_PEAK_FILE_INFIX}.bare.bed"
    
    awk '{print $1 "\t" $2 "\t" $3 }' "${peakfile}" > "${barepeakfile}"
    
    ) &

done







echo "##################### intersect ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on intersect   ${cell}       $dt"
    tagalignFile="${TAGALIGN_DIR}${cell}${TAGALIGN_SUFFIX}"
    sort_tagalign_file="${TAGALIGN_DIR}${cell}.sort.tagalign"
    intersect_file="${intersect_DIR}${cell}.intersect_vs_merged_peaks.bed"
    barepeakfile="${bare_peak_DIR}${cell}${BARE_PEAK_FILE_INFIX}.bare.bed"
    
    bedtools intersect -a ${barepeakfile} -b ${tagalignFile} -wa -wb -sorted > ${intersect_file}
    
    ) &

done


echo "##################### make intersect less col files ###############################"
# intersect file columns:
#    1           2        3           4          5              6             7     8  9
# peak_chrom peak_Start peak_end tagalign_chrom tagalign_start tagalign_end barcode q strand

for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on less col   ${cell}       $dt"
    intersect_file="${intersect_DIR}${cell}.intersect_vs_merged_peaks.bed"
    intermed_intersect_less_col_file="${intersect_lessCol_DIR}${cell}.intersect_vs_merged_peaks.lesscol.txt"
    awk '{print $1 ":" $2 "-" $3 "\t" $7 }' "${intersect_file}" > "${intermed_intersect_less_col_file}"
    
    ) &

done





echo "##################### make lft mtx unsort ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx unsort   ${cell}       $dt"
    intermed_intersect_less_col_file="${intersect_lessCol_DIR}${cell}.intersect_vs_merged_peaks.lesscol.txt"
    lft_mtx_unsort_file="${lft_mtx_unsort_dir}${cell}.lftmtx.unsort.txt"
    awk '{
    combination = $1 "\t" $2
    count[combination]++
    }
    END {
        for (comb in count) {
            print comb, count[comb]
        }
    }' "${intermed_intersect_less_col_file}" > "${lft_mtx_unsort_file}"
)&
done





echo "##################### make lft mtx sort ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx sort   ${cell}       $dt"
    lft_mtx_unsort_file="${lft_mtx_unsort_dir}${cell}.lftmtx.unsort.txt"
    lft_mtx_sort_file="${lft_mtx_sort_dir}${cell}.lftmtx.sort.mtx"
    sort -k1,1 -k2,2n  "${lft_mtx_unsort_file}" > "${lft_mtx_sort_file}"

    
    ) &

done



echo "##################### make mm ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx -> mm   ${cell}       $dt"

    lft_mtx_sort_file="${lft_mtx_sort_dir}${cell}.lftmtx.sort.mtx"
    mm_file="${mm_dir}${cell}.mm.mtx"
    
    Rscript ${LFT_2_MM_SCRIPT} ${lft_mtx_sort_file} ${mm_file} ${cell}
    
    # infile = args[1]
    # outfile = args[2]
    # celltypename = args[3]
    
    
    
    
    ) &

done



exit 0
