#!/usr/bin/env bash


SET_DIRS[1]="/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/celltype/peaks/"
SET_DIRS[2]="/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/merged_to_celltype/peaks_merged/"
SET_DIRS[3]="/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/fixed_peaks/celltype/peaks/"
SET_DIRS[4]="/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/fixed_peaks/merged_to_celltype/peaks/"

SET_NAMES[1]="normal_cell"
SET_NAMES[2]="normal_merged"
SET_NAMES[3]="fixed_cell"
SET_NAMES[4]="fixed_merged"


SET_SUFFIX_INPUTS[1]=".celltype_spec_peaks.bare.filt.bed"
SET_SUFFIX_INPUTS[2]=".peaks_merged_from_treatment_celltype.merged.peak.bare.filt.bed"
SET_SUFFIX_INPUTS[3]=".fixed_peaks.400bp.bare.filt.bed"
SET_SUFFIX_INPUTS[4]=".peaks_merged_from_fixed_400bp_treatment_celltype.merged.peak.bare.filt.bed"

SET_SUFFIX_OUTPUTS[1]=".celltype_peaks.bare.filt.anno.bed"
SET_SUFFIX_OUTPUTS[2]=".peaks_merged_from_treat_cell.merged.peak.bare.filt.anno.bed"
SET_SUFFIX_OUTPUTS[3]=".fixed_peaks.400bp.bare.filt.anno.bed"
SET_SUFFIX_OUTPUTS[4]=".peaks_merged_from_fixed_400bp_treat_cell.merged.peak.bare.filt.anno.bed"


CELLTYPES=(alpha alpha_1 alpha_2 alpha_3 alpha_4 stellate beta beta_1 beta_2 ductal delta acinar immune gamma endothelial schwann activated_stellate    unk_stellate quiescent_stellate monocyte mast)
# ln -s /nfs/lab/ABC/references/gene_coords.gencodev32.hg38.TSS500bp.bed gene_coords.gencodev32.hg38.TSS500bp.bed
PROM_BED=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/ref/gene_coords.gencodev32.hg38.TSS500bp.bed

dt=$(date '+%d/%m/%Y %H:%M:%S');
echo ""
echo ""
echo "=========="
echo "INTERSECT PEAKS"
echo "=========="
echo "$dt"
echo ""
echo ""

N=5

for i in "${!SET_DIRS[@]}"; do
        SET_DIR="${SET_DIRS[$i]}"
        set_name="${SET_NAMES[$i]}"

        set_input_dir="${SET_DIR}peaks_blacklist_filt/"
        set_output_dir="${SET_DIR}peaks_filt_anno/"

        set_suffix_input="${SET_SUFFIX_INPUTS[$i]}"
        set_suffix_output="${SET_SUFFIX_OUTPUTS[$i]}"

       for cell in ${CELLTYPES[@]}; do 
            ((i=i%N)); ((i++==0)) && wait

            (
            dt=$(date '+%d/%m/%Y %H:%M:%S');
            echo "working on ${set_name}   ${cell}       $dt"

            input_peaks="${set_input_dir}${cell}${set_suffix_input}"
            output_anno_peaks="${set_output_dir}${cell}${set_suffix_output}"
            intermed_intersect="${set_output_dir}${cell}${set_suffix_output}.intermed__intersect.bed"
            intermed_outersect="${set_output_dir}${cell}${set_suffix_output}.intermed__outersect.bed"
            intermed_intersect_fix_col="${set_output_dir}${cell}${set_suffix_output}.intermed__intersect_fix_col.bed"
            intermed_outersect_fix_col="${set_output_dir}${cell}${set_suffix_output}.intermed__outersect_fix_col.bed"
            intermed_cat="${set_output_dir}${cell}${set_suffix_output}.intermed__cat.bed"


            bedtools intersect -a ${input_peaks} -b ${PROM_BED} -wa -wb > ${intermed_intersect}
            bedtools intersect -a ${input_peaks} -b ${PROM_BED} -wa -v > ${intermed_outersect}

            awk '{print $1 ":" $2 "-" $3 "\t" $7 }' "$intermed_intersect" > "$intermed_intersect_fix_col"
            awk '{print $1 ":" $2 "-" $3 "\t" $1 ":" $2 "-" $3 }' "$intermed_outersect" > "$intermed_outersect_fix_col"

            cat "$intermed_intersect_fix_col" "$intermed_outersect_fix_col" > "${intermed_cat}"
            sort -k1,1 -k2,2n "${intermed_cat}" > "${output_anno_peaks}"

        ) &

    done

done


echo "DONE!!!!!!"
exit 0
