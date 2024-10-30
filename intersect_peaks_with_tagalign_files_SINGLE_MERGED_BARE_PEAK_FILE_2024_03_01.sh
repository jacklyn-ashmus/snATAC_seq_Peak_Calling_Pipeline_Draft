#!/usr/bin/env bash

CELLTYPE_FILE=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/celltype_list.txt
TAGALIGN_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/softlinks/tagalign/treatment_celltype/
TAGALIGN_SUFFIX=.tagalign
MERGED_PEAK_FILE=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/peaks_from_emily/peak_calls/Jackie_UnionPeaks.bare.sort.bed
OUTPUT_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/peaks_from_emily/counts_matrix/treatment_celltype/
N=8
LFT_2_MM_SCRIPT=/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/lft_mtx_2_sparseMatrix.R


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



echo "##################### intersect ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on intersect  CoCl2__ ${cell}       $dt"
    tagalignFile="${TAGALIGN_DIR}CoCl2__${cell}${TAGALIGN_SUFFIX}"
    intersect_file="${OUTPUT_DIR}CoCl2__${cell}.intersect_vs_merged_peaks.bed"
    
    bedtools intersect -a ${MERGED_PEAK_FILE} -b ${tagalignFile} -wa -wb -sorted > ${intersect_file}
    
    ) &

done



for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on intersect  Unt__ ${cell}       $dt"
    tagalignFile="${TAGALIGN_DIR}Unt__${cell}${TAGALIGN_SUFFIX}"
    intersect_file="${OUTPUT_DIR}Unt__${cell}.intersect_vs_merged_peaks.bed"
    
    bedtools intersect -a ${MERGED_PEAK_FILE} -b ${tagalignFile} -wa -wb -sorted > ${intersect_file}
    
    ) &

done




# # echo "##################### make intersect less col files ###############################"
# # # intersect file columns:
# # #    1           2        3           4          5              6             7     8  9
# # # peak_chrom peak_Start peak_end tagalign_chrom tagalign_start tagalign_end barcode q strand

for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on less col CoCl2__  ${cell}       $dt"
    intersect_file="${OUTPUT_DIR}CoCl2__${cell}.intersect_vs_merged_peaks.bed"
    intermed_intersect_less_col_file="${intersect_lessCol_DIR}CoCl2__${cell}.intersect_vs_merged_peaks.lesscol.txt"
    awk '{print $1 ":" $2 "-" $3 "\t" $7 }' "${intersect_file}" > "${intermed_intersect_less_col_file}"
    
    ) &

done



for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on less col Unt__  ${cell}       $dt"
    intersect_file="${OUTPUT_DIR}Unt__${cell}.intersect_vs_merged_peaks.bed"
    intermed_intersect_less_col_file="${intersect_lessCol_DIR}Unt__${cell}.intersect_vs_merged_peaks.lesscol.txt"
    awk '{print $1 ":" $2 "-" $3 "\t" $7 }' "${intersect_file}" > "${intermed_intersect_less_col_file}"
    
    ) &

done




# # echo "##################### make lft mtx unsort ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx unsort CoCl2__  ${cell}       $dt"
    intermed_intersect_less_col_file="${OUTPUT_DIR}CoCl2__${cell}.intersect_vs_merged_peaks.lesscol.txt"
    lft_mtx_unsort_file="${OUTPUT_DIR}CoCl2__${cell}.lftmtx.unsort.txt"
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



for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx unsort  Unt__ ${cell}       $dt"
    intermed_intersect_less_col_file="${OUTPUT_DIR}Unt__${cell}.intersect_vs_merged_peaks.lesscol.txt"
    lft_mtx_unsort_file="${OUTPUT_DIR}Unt__${cell}.lftmtx.unsort.txt"
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





# echo "##################### make lft mtx sort ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx sort CoCl2__  ${cell}       $dt"
    lft_mtx_unsort_file="${OUTPUT_DIR}CoCl2__${cell}.lftmtx.unsort.txt"
    lft_mtx_sort_file="${OUTPUT_DIR}CoCl2__${cell}.lftmtx.sort.mtx"
    sort -k1,1 -k2,2n  "${lft_mtx_unsort_file}" > "${lft_mtx_sort_file}"

    
    ) &

done


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx sort  Unt__ ${cell}       $dt"
    lft_mtx_unsort_file="${OUTPUT_DIR}Unt__${cell}.lftmtx.unsort.txt"
    lft_mtx_sort_file="${OUTPUT_DIR}Unt__${cell}.lftmtx.sort.mtx"
    sort -k1,1 -k2,2n  "${lft_mtx_unsort_file}" > "${lft_mtx_sort_file}"

    
    ) &

done



# echo "##################### make mm ###############################"


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx -> mm  CoCl2__ ${cell}       $dt"

    lft_mtx_sort_file="${OUTPUT_DIR}CoCl2__${cell}.lftmtx.sort.mtx"
    mm_file="${OUTPUT_DIR}CoCl2__${cell}.mm.mtx"
    
    Rscript ${LFT_2_MM_SCRIPT} ${lft_mtx_sort_file} ${mm_file} ${cell}
 
    ) &
done


for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on lft mtx -> mm Unt__  ${cell}       $dt"

    lft_mtx_sort_file="${OUTPUT_DIR}Unt__${cell}.lftmtx.sort.mtx"
    mm_file="${OUTPUT_DIR}Unt__${cell}.mm.mtx"
    
    Rscript ${LFT_2_MM_SCRIPT} ${lft_mtx_sort_file} ${mm_file} ${cell}
    
    ) &
done



exit 0
