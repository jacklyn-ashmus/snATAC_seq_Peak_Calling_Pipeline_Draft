#!/bin/bash

TREATMENTS=(CoCl2 Unt)
CELLTYPES=(acinar activated_stellate alpha alpha_1 alpha_2 alpha_3 alpha_4 beta beta_1 beta_2 delta ductal endothelial gamma immune mast monocyte quiescent_stellate quiescent_stellate_1 schwann stellate unk_stellate unk_stellate_2)






IN_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/softlinks/narrowPeak_treatment_celltype/
INTERMED_DIR1=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/merged_to_celltype/intermed_file/
INTERMED_DIR2=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/merged_to_celltype/intermed_file2/
OUT_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/merged_to_celltype/merged_peak_files/








N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
        # echo "$cell"
            unt_var="Unt__${cell}"
            cocl2_var="CoCl2__${cell}"
            cocl2_file="${IN_PEAK_DIR}CoCl2__${cell}_peaks.narrowPeak"
            unt_file="${IN_PEAK_DIR}Unt__${cell}_peaks.narrowPeak"
            cut_cocl2_file="${INTERMED_DIR1}CoCl2__${cell}.cutpeaks"
            cut_unt_file="${INTERMED_DIR1}Unt__${cell}.cutpeaks"
            cat_file="${INTERMED_DIR2}${cell}.concatenated_peaks"
            cat_sort_file="${INTERMED_DIR2}${cell}.concatenated_peaks.sort.bed"
            cat_cut_filt_file="${INTERMED_DIR2}${cell}.concatenated_peaks.sort.filt.bed"

            merged_file="${OUT_PEAK_DIR}${cell}.peaks_merged_from_treatment_celltype.merged.peak.bed"
            merged_bare_file="${OUT_PEAK_DIR}${cell}.peaks_merged_from_treatment_celltype.merged.peak.bare.bed"
            echo "$cell unt cut"      
            awk -v var="$unt_var" '{print $1 "\t" $2 "\t" $3 "\t"  var}' ${unt_file} > ${cut_unt_file}

            echo "$cell cocl2 cut"      
            awk -v var="$cocl2_var" '{print $1 "\t" $2 "\t" $3 "\t"  var}' ${cocl2_file} > ${cut_cocl2_file}

            echo "$cell cat"   
            cat ${cut_cocl2_file} ${cut_unt_file} > ${cat_file}
            echo "$cell sort"   
            sort -k1,1 -k2,2n ${cat_file} > ${cat_sort_file}

            echo "$cell intersect"   
            bedtools intersect -a ${cat_sort_file} \
            -b /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/ref/hg38-blacklist.v2.bed \
            -v > ${cat_cut_filt_file}
            echo "$cell merge"   
            bedtools merge -i ${cat_cut_filt_file} -c 4 -o collapse > ${merged_file}
            echo "$cell bare"   
            awk '{print $1 "\t" $2 "\t" $3 }' ${merged_file} > ${merged_bare_file}
    

    
    ) &

done

echo "DONE!"
exit 0
