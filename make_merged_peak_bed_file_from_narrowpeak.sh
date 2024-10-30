#!/bin/bash

IN_PEAK_DIR=$1 # input directory with the narrowpeak files from macs2
OUT_PEAK_DIR=$2 # directory for writing the merged (and intermediate files to)
OUTNAME_BASE=$3 # base name for output files like sample or project name or whatever
CELLTYPES_FILE=$4 #file with celltypes or celltypes/treatment names (for file prefixes) in single column, eg:
                      # CoCl2__acinar
                      # CoCl2__activated_stellate
                      # Unt__acinar
                      # Unt__activated_stellate
                      
ENCODE_BLACKLIST_FILE=$5 # /nfs/lab/ref/hg38-blacklist.v2.bed
REMOVE_EXTRA_FILES=$6 # == 1 if you want to remove intermediate files that are created here



echo ""
echo ""
echo ""

# make sure output IN_PEAK_DIR path ends in slash
if  [[ $IN_PEAK_DIR != */ ]];
then
    IN_PEAK_DIR="${IN_PEAK_DIR}/"
fi



# make sure output OUT_PEAK_DIR path ends in slash
if  [[ $OUT_PEAK_DIR != */ ]];
then
    OUT_PEAK_DIR="${OUT_PEAK_DIR}/"
fi

# echo "IN_PEAK_DIR = ${IN_PEAK_DIR}"
# echo "OUT_PEAK_DIR = ${OUT_PEAK_DIR}"
# echo "OUTNAME_BASE = ${OUTNAME_BASE}"
# echo "CELLTYPES_FILE = ${CELLTYPES_FILE}"
# echo "ENCODE_BLACKLIST_FILE = ${ENCODE_BLACKLIST_FILE}"
# echo "REMOVE_EXTRA_FILES = ${REMOVE_EXTRA_FILES}"




cat_file="${OUT_PEAK_DIR}${OUTNAME_BASE}.concatenated.bed"
cat_sorted_file="${OUT_PEAK_DIR}${OUTNAME_BASE}.concatenated.sorted.bed"
cat_sorted_filtered_file="${OUT_PEAK_DIR}${OUTNAME_BASE}.concatenated.sorted.filtered.bed"
output_merged_bed="${OUT_PEAK_DIR}${OUTNAME_BASE}.sorted.merged.filtered.bed"
output_merged_bare_bed="${OUT_PEAK_DIR}${OUTNAME_BASE}.sorted.merged.filtered.bare.bed"

# read cluster names into array from file
readarray -t celltypes < ${CELLTYPES_FILE}

# echo "celltypes:"
# echo "${celltypes[@]}"
# echo ""

echo "make bare individual peak bed files"
for cell in "${celltypes[@]}"; do
    in_narrowpeak_file="${IN_PEAK_DIR}${cell}_peaks.narrowPeak"
    out_bed_file="${OUT_PEAK_DIR}${cell}.peaks.bed"
    echo "${out_bed_file}"
    awk -v OFS="\t" -v n="$cell" '{print $1,$2,$3, n }' ${in_narrowpeak_file} > ${out_bed_file}
done

echo "concatenate bed files"
for cell in "${celltypes[@]}"; do
    bedfile="${OUT_PEAK_DIR}${cell}.peaks.bed"
    cat "${bedfile}"
done > ${cat_file}

echo "sort concatenated bed files"
sort -k1,1 -k2,2n ${cat_file} > ${cat_sorted_file}

echo "remove ENCODE blacklisted sites"
bedtools intersect -a ${cat_sorted_file} -b ${ENCODE_BLACKLIST_FILE}  -wa -v > ${cat_sorted_filtered_file}

echo "bedtools merge"
bedtools merge -i ${cat_sorted_filtered_file} -c 4 -o collapse > ${output_merged_bed}

echo "strip "
awk '{print $1 "\t" $2 "\t" $3  }' "${output_merged_bed}" > "${output_merged_bare_bed}"



if  [[ $REMOVE_EXTRA_FILES == 1 ]];
then
    
    
    echo "removing individual bare peak bed files "
    for cell in "${celltypes[@]}"; do
        out_bed_file="${OUT_PEAK_DIR}${cell}.peaks.bed"
        rm ${out_bed_file}
    done
    
    echo "remove cat file"
    rm ${cat_file}
    
    echo "remove cat sorted file"
    rm ${cat_sorted_file}
    
    echo "remove cat sorted filtered file"
    rm ${cat_sorted_filtered_file}
    
fi # end if for remove files

echo ""
echo ""

echo "DONE!!"
exit 0
