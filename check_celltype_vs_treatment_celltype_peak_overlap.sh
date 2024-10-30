#!/usr/bin/env bash


CELLTYPE_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/celltype/peaks/peaks_blacklist_filt/
# beta_1.celltype_spec_peaks.bare.filt.bed
TREATMENT_CELLTYPE_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/treatment_celltype/peaks/peaks_blacklist_filt/
# CoCl2__acinar.peaks.bare.filt.bed
MERGED_2_CELLTYPE_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/merged_to_celltype/peaks_merged/peaks_blacklist_filt/
# gamma.peaks_merged_from_treatment_celltype.merged.peak.bare.filt.bed
OUTDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/peak_overlap_check/


CELLTYPES=(alpha alpha_1 alpha_2 alpha_3 alpha_4 stellate beta beta_1 beta_2 ductal delta acinar immune gamma endothelial schwann activated_stellate    unk_stellate quiescent_stellate monocyte mast)




N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

        celltypeF="${CELLTYPE_PEAK_DIR}${cell}.celltype_spec_peaks.bare.filt.bed"
        mergedF="${MERGED_2_CELLTYPE_PEAK_DIR}${cell}.peaks_merged_from_treatment_celltype.merged.peak.bare.filt.bed"
        cocl2="${TREATMENT_CELLTYPE_PEAK_DIR}CoCl2__${cell}.peaks.bare.filt.bed"
        unt="${TREATMENT_CELLTYPE_PEAK_DIR}Unt__${cell}.peaks.bare.filt.bed"



        # celltype v merge
            #  celltype AND merge
                echo "${cell} celltype v merge: celltype AND merge"
                outfile_celltype_v_merge_BOTH="${OUTDIR}${cell}.cell_v_merge.OVERLAP"
                bedtools intersect -a ${celltypeF} -b ${mergedF} -wa -wb -sorted > ${outfile_celltype_v_merge_BOTH}
            # celltype not merge
                echo "${cell} celltype v merge: celltype NOT merge"
                outfile_celltype_v_merge_CELL="${OUTDIR}${cell}.cell_v_merge.cell_ONLY"
                bedtools intersect -a ${celltypeF} -b ${mergedF} -wa -v -sorted > ${outfile_celltype_v_merge_CELL}
                
                
            # merge not celltype
                echo "${cell} celltype v merge: merge NOT celltype"
                outfile_celltype_v_merge_MERGE="${OUTDIR}${cell}.cell_v_merge.merge_ONLY"
                bedtools intersect -a ${mergedF} -b ${celltypeF} -wa -v -sorted > ${outfile_celltype_v_merge_MERGE}

                
        # celltype v cocl2 
        #    celltype AND cocl2
                echo "${cell} celltype v cocl2: celltype AND cocl2"
                outfile_celltype_v_cocl2_BOTH="${OUTDIR}${cell}.cell_v_cocl2.OVERLAP"
                bedtools intersect -a ${celltypeF} -b ${cocl2} -wa -wb -sorted > ${outfile_celltype_v_cocl2_BOTH}
                
        #   celltype NOT cocl2 
                echo "${cell} celltype v cocl2: celltype NOT cocl2"
                outfile_celltype_v_cocl2_CELL="${OUTDIR}${cell}.cell_v_cocl2.cell_ONLY"
                bedtools intersect -a ${celltypeF} -b ${cocl2} -wa -v -sorted > ${outfile_celltype_v_cocl2_CELL}
         
        #   cocl2 NOT celltype
                echo "${cell} celltype v cocl2: cocl2 NOT celltype"
                outfile_celltype_v_cocl2_COCL2="${OUTDIR}${cell}.cell_v_cocl2.cocl2_ONLY"
                bedtools intersect -a ${cocl2} -b ${celltypeF} -wa -v -sorted > ${outfile_celltype_v_cocl2_COCL2}
         


         
        # celltyp v unt
        #     celltype AND UNT
                echo "${cell} celltyp v unt: celltype AND UNT"
                outfile_celltype_v_unt_BOTH="${OUTDIR}${cell}.cell_v_unt.OVERLAP"
                bedtools intersect -a ${celltypeF} -b ${unt} -wa -wb -sorted > ${outfile_celltype_v_unt_BOTH}
                
        #     celltype NOT unt
                echo "${cell} celltyp v unt: celltype NOT unt"
                outfile_celltype_v_unt_CELL="${OUTDIR}${cell}.cell_v_unt.cell_ONLY"
                bedtools intersect -a ${celltypeF} -b ${unt} -wa -v -sorted > ${outfile_celltype_v_unt_CELL}
                
        #      unt NOT celltype
                echo "${cell} celltyp v unt: unt NOT celltype"
                outfile_celltype_v_unt_UNT="${OUTDIR}${cell}.cell_v_unt.unt_ONLY"
                bedtools intersect -a ${unt} -b ${celltypeF} -wa -v -sorted > ${outfile_celltype_v_unt_UNT}
          

        # merged v cocl2
        #     merged AND cocl2 
                echo "${cell} merged v cocl2: merged AND cocl2"
                outfile_merged_v_cocl2_BOTH="${OUTDIR}${cell}.merge_v_cocl2.OVERLAP"
                bedtools intersect -a ${mergedF} -b ${cocl2} -wa -wb -sorted > ${outfile_merged_v_cocl2_BOTH}
                
        #     merged NOT cocl2
                echo "${cell} merged v cocl2: merged NOT cocl2"
                outfile_merged_v_cocl2_MERGE="${OUTDIR}${cell}.merge_v_cocl2.merge_ONLY"
                bedtools intersect -a ${mergedF} -b ${cocl2} -wa -v -sorted > ${outfile_merged_v_cocl2_MERGE}
                

        
        #     cocl2 NOT merged
                echo "${cell} merged v cocl2: cocl2 NOT merged"
                outfile_merge_v_cocl2_COCL2="${OUTDIR}${cell}.merge_v_cocl2.cocl2_ONLY"
                bedtools intersect -a ${cocl2} -b ${mergedF} -wa -v -sorted > ${outfile_merge_v_cocl2_COCL2}
          


        # merged v unt 
        #     merged AND unt
                echo "${cell} merged v unt: merged AND unt"
                outfile_merged_v_unt_BOTH="${OUTDIR}${cell}.merged_v_unt.OVERLAP"
                bedtools intersect -a ${mergedF} -b ${unt} -wa -wb -sorted > ${outfile_merged_v_unt_BOTH}
                
        #     merged NOT unt
                echo "${cell} merged v cocl2: merged NOT unt"
                outfile_merged_v_unt_MERGE="${OUTDIR}${cell}.merged_v_unt.merge_ONLY"
                bedtools intersect -a ${mergedF} -b ${unt} -wa -v -sorted > ${outfile_merged_v_unt_MERGE}
                
        #     unt NOT merged
                echo "${cell} merged v cocl2: unt NOT merged"
                outfile_merged_v_unt_Unt="${OUTDIR}${cell}.merged_v_unt.unt_ONLY"
                bedtools intersect -a ${unt} -b ${mergedF} -wa -v -sorted > ${outfile_merged_v_unt_Unt}


                
        # cocl2 v unt
        #      cocl2 AND unt
                echo "${cell} cocl2 v unt: cocl2 AND unt"
                outfile_cocl2_v_unt_BOTH="${OUTDIR}${cell}.cocl2_v_unt.OVERLAP"
                bedtools intersect -a ${cocl2} -b ${unt} -wa -wb -sorted > ${outfile_cocl2_v_unt_BOTH}
                
        #      cocl2 NOT unt
                echo "${cell} cocl2 v unt: cocl2 NOT unt"
                outfile_cocl2_v_unt_cocl2="${OUTDIR}${cell}.cocl2_v_unt.cocl2_ONLY"
                bedtools intersect -a ${cocl2} -b ${unt} -wa -v -sorted > ${outfile_cocl2_v_unt_cocl2}

        
        #       unt NOT cocl2
                echo "${cell} cocl2 v unt: cocl2 NOT unt"
                outfile_cocl2_v_unt_UNT="${OUTDIR}${cell}.cocl2_v_unt.unt_ONLY"
                bedtools intersect -a ${unt} -b ${cocl2} -wa -v -sorted > ${outfile_cocl2_v_unt_UNT}





        
    ) &

done


exit 0
