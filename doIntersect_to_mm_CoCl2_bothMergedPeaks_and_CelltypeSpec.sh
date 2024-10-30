#!/usr/bin/env bash


cells=(CoCl2__acinar CoCl2__activated_stellate CoCl2__alpha CoCl2__alpha_1 CoCl2__alpha_2 CoCl2__alpha_3 CoCl2__alpha_4 CoCl2__beta CoCl2__beta_1 CoCl2__beta_2 CoCl2__delta CoCl2__ductal CoCl2__endothelial CoCl2__gamma CoCl2__immune CoCl2__mast CoCl2__monocyte CoCl2__quiescent_stellate_1 CoCl2__schwann CoCl2__stellate CoCl2__unk_stellate_2 Unt__acinar Unt__activated_stellate Unt__alpha Unt__alpha_1 Unt__alpha_2 Unt__alpha_3 Unt__alpha_4 Unt__beta Unt__beta_1 Unt__beta_2 Unt__delta Unt__ductal Unt__endothelial Unt__gamma Unt__immune Unt__mast Unt__monocyte Unt__quiescent_stellate_1 Unt__schwann Unt__stellate Unt__unk_stellate_2  )



MTX_SCRIPT=/nfs/lab/jnewsome/scripts/multiome_CoCl2/peakCalls/lft_mtx_2_sparseMatrix.R

TAGALIGN_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/tagalign_softlinks/

INTERSECT_OUTPUT_TO_LFT_MTX_SCRIPT=/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/peak_intersect_tagalign_file_to_lft_mtx_new_awk_version_v2_moreInputs.sh


MERGED_PEAK_FILE=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/merged_peaks/narrowpeak_softlinks/merged.peaks_from_cellsubtypes.bed

CELLTYPE_SPEC_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/celltype_specific_peaks/narrowpeak_softlinks/



#######
## CELLTYPE SPEC OUTDIRS
CELLTYPE_SPEC_OUT_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/celltype_specific_peaks/
CELLTYPE_SPEC_INTERSECT_OUT_DIR="${CELLTYPE_SPEC_OUT_DIR}intersect/"  
CELLTYPE_SPEC_INTERSECT_OUT_LESS_COL_DIR="${CELLTYPE_SPEC_OUT_DIR}intersect_lessCol/"
CELLTYPE_SPEC_LFT_UNSORT_DIR="${CELLTYPE_SPEC_OUT_DIR}lft_mtx/"    
CELLTYPE_SPEC_LFT_SORT_DIR="${CELLTYPE_SPEC_OUT_DIR}lft_mtx_sort/"    
CELLTYPE_SPEC_MM_DIR="${CELLTYPE_SPEC_OUT_DIR}mm_mtx/"    
#######
## MERGED PEAK OUTDIRS
MERGED_PEAK_OUT_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/merged_peaks/
MERGED_PEAK_INTERSECT_OUT_DIR="${MERGED_PEAK_OUT_DIR}intersect/"  
MERGED_PEAK_INTERSECT_OUT_LESS_COL_DIR="${MERGED_PEAK_OUT_DIR}intersect_lessCol/" 
MERGED_PEAK_LFT_UNSORT_DIR="${MERGED_PEAK_OUT_DIR}lft_mtx/"    
MERGED_PEAK_LFT_SORT_DIR="${MERGED_PEAK_OUT_DIR}lft_mtx_sort/"    
MERGED_PEAK_MM_DIR="${MERGED_PEAK_OUT_DIR}mm_mtx/"    




echo "####################################################"
echo "############ Celltype Specific  ####################"
echo "####################################################"

####################################################
############ Celltype Specific  ####################
####################################################





# ########### 1. intersect #####################
# echo "########### 1. intersect #####################"

# N=6

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait
#     (
       
#        tagalignFile="${TAGALIGN_DIR}${cell}.tagalign"
#        peakFile="${CELLTYPE_SPEC_PEAK_DIR}${cell}_peaks.narrowPeak"
#        intersectFile="${CELLTYPE_SPEC_INTERSECT_OUT_DIR}${cell}.celltype_specific_peak_intersect_tagalign.bed"
#        lft_mtxFile="${MERGED_PEAK_LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"
#        mtxFile="${CELLTYPE_SPEC_MM_DIR}${cell}.mm.mtx"
#        echo "$cell CTS intersect"
#        bedtools intersect -a ${peakFile} -b ${tagalignFile} -wa -wb -sorted > ${intersectFile}
   
#     ) &

# done




########### 2. lft mtx #####################
echo "########### 2. lft mtx #####################"


N=6

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       tagalignFile="${TAGALIGN_DIR}${cell}.tagalign"
       peakFile="${CELLTYPE_SPEC_PEAK_DIR}${cell}_peaks.narrowPeak"
       intersectFile="${CELLTYPE_SPEC_INTERSECT_OUT_DIR}${cell}.celltype_specific_peak_intersect_tagalign.bed"
       lft_mtxFile="${MERGED_PEAK_LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"
       mtxFile="${CELLTYPE_SPEC_MM_DIR}${cell}.mm.mtx"
   
       echo "$cell CTS intersect output --> lft mtx"
   
       #      script                           infile          celltype          INFILE_INTERMED_DIR                    LFT_UNSORT_DIR   LFT_SORT_DIR
       ${INTERSECT_OUTPUT_TO_LFT_MTX_SCRIPT} ${intersectFile} ${cell} 14  ${CELLTYPE_SPEC_INTERSECT_OUT_LESS_COL_DIR} ${CELLTYPE_SPEC_LFT_UNSORT_DIR} ${CELLTYPE_SPEC_LFT_SORT_DIR}
   
    ) &

done




########### 3. mm #####################
echo "########### 3. mm #####################"



N=6

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       tagalignFile="${TAGALIGN_DIR}${cell}.tagalign"
       peakFile="${CELLTYPE_SPEC_PEAK_DIR}${cell}_peaks.narrowPeak"
       intersectFile="${CELLTYPE_SPEC_INTERSECT_OUT_DIR}${cell}.celltype_specific_peak_intersect_tagalign.bed"
       lft_mtxFile="${MERGED_PEAK_LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"
       mtxFile="${CELLTYPE_SPEC_MM_DIR}${cell}.mm.mtx"
       
       echo "$cell CTS lft mtx to mm"
   
        Rscript ${MTX_SCRIPT}   ${lft_mtxFile} ${mtxFile} ${cell}
    ) &

done










echo "####################################################"
echo "################# Merged Peaks  ####################"
echo "####################################################"

###################################################
########### Merged Peaks  ####################
###################################################



########### 1. intersect #####################
echo "########### 1. intersect #####################"



N=6

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       tagalignFile="${TAGALIGN_DIR}${cell}.tagalign"
       intersectFile="${MERGED_PEAK_INTERSECT_OUT_DIR}${cell}.merged_peak_intersect_tagalign.bed"
       lft_mtxFile="${MERGED_PEAK_LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"
       mtxFile="${MERGED_PEAK_MM_DIR}${cell}.mm.mtx"
       echo "$cell merged intersect"
       
       bedtools intersect -a ${MERGED_PEAK_FILE} -b ${tagalignFile} -wa -wb -sorted > ${intersectFile}
   
    ) &

done



########### 2. lft mtx #####################
echo "########### 2. lft mtx #####################"



N=6

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       tagalignFile="${TAGALIGN_DIR}${cell}.tagalign"
       intersectFile="${MERGED_PEAK_INTERSECT_OUT_DIR}${cell}.celltype_specific_peak_intersect_tagalign.bed"
       lft_mtxFile="${MERGED_PEAK_LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"
       mtxFile="${MERGED_PEAK_MM_DIR}${cell}.mm.mtx"
 
       echo "$cell merged intersect output --> lft mtx"
   
       #      script                           infile          celltype          INFILE_INTERMED_DIR                    LFT_UNSORT_DIR   LFT_SORT_DIR
       ${INTERSECT_OUTPUT_TO_LFT_MTX_SCRIPT} ${intersectFile} ${cell} 7 ${MERGED_PEAK_INTERSECT_OUT_LESS_COL_DIR} ${MERGED_PEAK_LFT_UNSORT_DIR} ${MERGED_PEAK_LFT_SORT_DIR}
   

    ) &

done



########### 3. mm #####################
echo "########### 3. mm #####################"



N=6

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       tagalignFile="${TAGALIGN_DIR}${cell}.tagalign"
       intersectFile="${MERGED_PEAK_INTERSECT_OUT_DIR}${cell}.celltype_specific_peak_intersect_tagalign.bed"
       lft_mtxFile="${MERGED_PEAK_LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"
       mtxFile="${MERGED_PEAK_MM_DIR}${cell}.mm.mtx"
       echo "$cell merged lft mtx to mm"
   
        Rscript ${MTX_SCRIPT} ${lft_mtxFile} ${mtxFile} ${cell}
    ) &

done


echo " ########################### DONE!!!!! ############################"

exit 0
