#!/usr/bin/env bash


# /nfs/lab/jnewsome/scripts/softlink_all_files_in_directory.sh /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/celltype/peaks/narrowPeak /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/celltype/counts_matrix/treatment_celltype/peaks 

# /nfs/lab/jnewsome/scripts/softlink_all_files_in_directory.sh /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/Treatment__celltype /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/tagalign_softlinks


# /nfs/lab/jnewsome/scripts/softlink_all_files_in_directory.sh /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/celltype /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/tagalign_softlinks/celltype


CELLTYPES=(alpha alpha_1 alpha_2 alpha_3 alpha_4 stellate beta beta_1 beta_2 ductal delta acinar immune gamma endothelial schwann activated_stellate    unk_stellate quiescent_stellate monocyte mast)

OUTDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/fixed_peaks/celltype/counts_matrix/treatment_celltype/


TREATMENT_CELLTYPES=(CoCl2__alpha CoCl2__alpha_1 CoCl2__alpha_2 CoCl2__alpha_3 CoCl2__alpha_4 CoCl2__stellate CoCl2__beta CoCl2__beta_1 CoCl2__beta_2 CoCl2__ductal CoCl2__delta CoCl2__acinar CoCl2__immune CoCl2__gamma CoCl2__endothelial CoCl2__schwann CoCl2__activated_stellate CoCl2__unk_stellate CoCl2__quiescent_stellate CoCl2__monocyte CoCl2__mast Unt__alpha Unt__alpha_1 Unt__alpha_2 Unt__alpha_3 Unt__alpha_4 Unt__stellate Unt__beta Unt__beta_1 Unt__beta_2 Unt__ductal Unt__delta Unt__acinar Unt__immune Unt__gamma Unt__endothelial Unt__schwann Unt__activated_stellate Unt__unk_stellate Unt__quiescent_stellate Unt__monocyte Unt__mast )


MTX_SCRIPT=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/softlinks/lft_mtx_2_sparseMatrix.R


# PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/merged_to_celltype/merged_peak_files/



TAGALIGN_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/tagalign_softlinks/treatment_celltype/

BLACKLIST_FILE=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/ref/hg38-blacklist.v2.sort.bed

#######
## CELLTYPE SPEC OUTDIRS
PEAK_DIR_BASE=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/fixed_peaks/celltype/peaks/
FIX_PEAK_DIR="${PEAK_DIR_BASE}fixed_peaks/"  
PEAK_BARE_DIR="${PEAK_DIR_BASE}peaks_bare/"  
FILT_OUT_DIR="${PEAK_DIR_BASE}peaks_blacklist_filt/"  
INTERSECT_OUT_DIR="${OUTDIR}intermed/"  
INTERSECT_OUT_LESS_COL_DIR="${OUTDIR}intermed/"
LFT_UNSORT_DIR="${OUTDIR}lft_unsort/"    
LFT_DIR="${OUTDIR}lft_mtx/"    
MM_DIR="${OUTDIR}mm/"    

################# 0. filt peaks #############################
#############################################################
echo "################# 0. strip peaks #############################"
N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

        peak_file="${FIX_PEAK_DIR}${cell}.fixed_peaks.400bp.bed"
        bar_peak_file="${PEAK_BARE_DIR}${cell}.fixed_peaks.400bp.bare.bed"
    

       echo "$cell bare"
       awk '{print $1 "\t" $2 "\t" $3 }' "${peak_file}" > "${bar_peak_file}"
   
    ) &

done

echo "################# 0. filt peaks #############################" 

N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

        bar_peak_file="${PEAK_BARE_DIR}${cell}.fixed_peaks.400bp.bare.bed"
        filt_peak_file="${FILT_OUT_DIR}${cell}.fixed_peaks.400bp.bare.filt.bed"
    

       echo "$cell filt"
       bedtools intersect -a ${bar_peak_file} -b ${BLACKLIST_FILE} -wa -v -sorted > ${filt_peak_file}
   
    ) &

done




# ########### 1. intersect #####################
echo "########### 1. intersect #####################"

N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

      
      tagalign="${TAGALIGN_DIR}CoCl2__${cell}.tagalign"
      filt_peak_file="${FILT_OUT_DIR}${cell}.fixed_peaks.400bp.bare.filt.bed"
      intersect_file="${INTERSECT_OUT_DIR}CoCl2__${cell}.peak_intersect.bed"


      echo "$cell cocl2 intersect"
      bedtools intersect -a ${filt_peak_file} -b ${tagalign} -wa -wb -sorted > ${intersect_file}

    ) &

done



N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

      
      tagalign="${TAGALIGN_DIR}Unt__${cell}.tagalign"
      filt_peak_file="${FILT_OUT_DIR}${cell}.fixed_peaks.400bp.bare.filt.bed"
      intersect_file="${INTERSECT_OUT_DIR}Unt__${cell}.peak_intersect.bed"


      echo "$cell unt intersect"
      bedtools intersect -a ${filt_peak_file} -b ${tagalign} -wa -wb -sorted > ${intersect_file}

    ) &

done




# ########### 2. cut intersect #####################
echo "########### 2. cut intersect #####################"


N=6

for cell in ${TREATMENT_CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       intersect_file="${INTERSECT_OUT_DIR}${cell}.peak_intersect.bed"
       intersectFile_lessCol="${INTERSECT_OUT_LESS_COL_DIR}${cell}.peak_intersect.lesscol.txt"

        #  chr1    827394  827816  chr1    827351  827551  Pool1_Unt_PM001_PM003_ATAACGACACATTAAC-1        60      -
        #    1       2       3      4         5       6                    7                                8      9
        #    1       2      3                                              7                    
        echo "$cell cut intersect col"
        # echo "$cell = ${intersectFile}"
        echo "$cell intersect_file = $intersect_file"
        echo "$cell intersectFile_lessCol = $intersectFile_lessCol"
        awk '{print $1 ":" $2 "-" $3 "\t" $7}' "${intersect_file}" > "${intersectFile_lessCol}"
   
    ) &

done


# ########### 3. lft mtx  #####################
echo "########### 3.  lft mtx  #####################"


N=6

for cell in ${TREATMENT_CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

       intersectFile_lessCol="${INTERSECT_OUT_LESS_COL_DIR}${cell}.peak_intersect.lesscol.txt"
       lft_unsort="${LFT_UNSORT_DIR}${cell}.lftmtx.unsort.txt"
       lft_mtxfile="${LFT_SORT_DIR}${cell}.lftmtx.sort.mtx"


        echo "$cell lft mtx unsort"
        
        
        awk '{
            combination = $1 "\t" $2
            count[combination]++
        }
        END {
            for (comb in count) {
                print comb, count[comb]
            }
        }' "${intersectFile_lessCol}" > "${lft_unsort}"

    ) &

done








# # ########### 4. lft mtx sort  #####################
echo "########### 4.  lft mtx  sort #####################"


N=6

for cell in ${TREATMENT_CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       intersectFile="${INTERSECT_OUT_DIR}${cell}.celltype_specific_peak_intersect_tagalign.bed"
       intersectFile_lessCol="${INTERSECT_OUT_LESS_COL_DIR}${cell}.intersect.lesscol.txt"
       lft_unsort="${LFT_UNSORT_DIR}${cell}.lftmtx.unsort.txt"
       lft_mtxfile="${LFT_DIR}${cell}.lftmtx.sort.mtx"

        echo "$cell lft mtx sort"
        
        sort -k1,1 -k2,2n ${lft_unsort} > ${lft_mtxfile}
   
    ) &

done









# ########### 5. mm #####################
echo "########### 5. mm #####################"

N=6

for cell in ${TREATMENT_CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       lft_mtxfile="${LFT_DIR}${cell}.lftmtx.sort.mtx"
       mtxFile="${MM_DIR}${cell}.mm.mtx"
       
       echo "$cell CTS lft mtx to mm"
   
        Rscript ${MTX_SCRIPT}   ${lft_mtxfile} ${mtxFile} ${cell}
    ) &
done








echo " ########################### DONE!!!!! ############################"

exit 0
