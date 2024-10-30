#!/usr/bin/env bash

CELLTYPES=(alpha alpha_1 alpha_2 alpha_3 alpha_4 stellate beta beta_1 beta_2 ductal delta acinar immune gamma endothelial schwann activated_stellate    unk_stellate quiescent_stellate monocyte mast)
CELLTYPE_BAR_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/barcode_metadata_tables/remake_lists_2023_12/celltype/
# cocl2_sc_project.barcode_list.alpha_3.txt



DONORS=(1_SAMN22997021 5_HP-21310-01 4_R413 21197 21167)
DONORS_BAR_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/barcode_metadata_tables/remake_lists_2023_12/Donor/
# cocl2_sc_project.barcode_list.21167.txt

TREATMENTS=(CoCl2 Unt)
TREATMENT_BAR_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/barcode_metadata_tables/remake_lists_2023_12/Treatment/
# cocl2_sc_project.barcode_list.CoCl2.txt


SPLIT_SCRIPT=/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/split_tagalign_file_with_barcode_lists_v2.sh

MERGED_TAGALIGN=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/Treatment/merged.tagAlign
INPUT_TAGALIGN=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/MERGED.TAGALIGN

OUTDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/


TMPDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/tmp/

#############################
# SPLIT BY TREATMENT = 
#############################

N=2

for treat in ${TREATMENTS[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       barFile="${TREATMENT_BAR_DIR}cocl2_sc_project.barcode_list.${treat}.txt"
       outputFile="${OUTDIR}Treatment/${treat}.tagalign"
       intermed_dir="${OUTDIR}intermed/Treatment_celltype_Donor/"
       
       inputTagalign="${INPUT_TAGALIGN}"

       echo "Treatment = $treat"
        echo "       input = ${inputTagalign}  "
        echo "       output = ${outputFile}   "
        echo "       barlist = ${barFile}"
        echo "       intermed dir = ${intermed_dir}   "
    
    
        split_tagalign_file="${intermed_dir}${cell}.splitInit.tagalign"
        cp_sort_tagalign_file="${intermed_dir}${cell}.sort.tagalign2"
        gzip_copy_file1="${intermed_dir}${cell}.sort.tagalign2.gz"
        gzip_copy_file2="${outputFile}.gz"

        echo "grep $treat"
        
        grep -F -f ${barFile} ${inputTagalign} > ${split_tagalign_file}

        echo "sort $treat $dt"
        # sort split tagalign file
        sort -k1,1 -k2,2n ${split_tagalign_file} > ${outputFile}
        




       
    ) &

done

echo "Done"








##############################
## SPLIT BY CELLTYPE NOT TREATMENT = N=6 = 12 max
##############################


N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
        barFile="${CELLTYPE_BAR_DIR}cocl2_sc_project.barcode_list.${cell}.txt"
        inputTagalign="${MERGED_TAGALIGN}"
        outputFile="${OUTDIR}celltype/${cell}.tagalign"
        # initsplitFile="${OUTDIR}celltype/${cell}.initSplit.tagalign"

        dt_grepcell=$(date '+%d/%m/%Y %H:%M:%S');
     
        echo "grep $cell        $dt_grepcell"
        # grep -F -f ${barFile} ${inputTagalign} > ${initsplitFile}
        grep -F -f ${barFile} ${inputTagalign} > ${outputFile}

        # dt_sortcell=$(date '+%d/%m/%Y %H:%M:%S');

        
        # echo "sort $cell       $dt_sortcell"
        # sort -k1,1 -k2,2n -T ${TMPDIR} ${initsplitFile} > ${outputFile}

    ) &

done




#############################
# SPLIT BY CELLTYPE AND TREATMENT = N=6 = 12 max
#############################
cd /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/Treatment_celltype/
ln -s /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/Treatment/CoCl2.tagAlign CoCl2.tagAlign
ln -s /nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/Treatment/Unt.tagAlign Unt.tagAlign

N=6


TREATMENT_CELLTYPE_TAGALIGN_OUTDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/resplit/Treatment_celltype/

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
        barFile="${CELLTYPE_BAR_DIR}cocl2_sc_project.barcode_list.${cell}.txt"

        cocl2_tagalign_file="${TREATMENT_CELLTYPE_TAGALIGN_OUTDIR}CoCl2.tagAlign"
        unt_tagalign_file="${TREATMENT_CELLTYPE_TAGALIGN_OUTDIR}Unt.tagAlign"

        out_cocl2_file="${TREATMENT_CELLTYPE_TAGALIGN_OUTDIR}CoCl2__${cell}.tagAlign"
        out_unt_file="${TREATMENT_CELLTYPE_TAGALIGN_OUTDIR}Unt__${cell}.tagAlign"

        # out_cocl2_init_file="${TREATMENT_CELLTYPE_TAGALIGN_OUTDIR}CoCl2__${cell}.splitInit.tagAlign"
        # out_unt_init_file="${TREATMENT_CELLTYPE_TAGALIGN_OUTDIR}Unt__${cell}.splitInit.tagAlign"

        dt_grepcocl2=$(date '+%d/%m/%Y %H:%M:%S');
     
        echo "grep $cell CoCl2      $dt_grepcocl2"
        grep -F -f ${barFile} ${cocl2_tagalign_file} > ${out_cocl2_file}


       dt_grepunt=$(date '+%d/%m/%Y %H:%M:%S');
       
        echo "grep $cell Unt       $dt_grepunt"
        grep -F -f ${barFile} ${unt_tagalign_file} > ${out_unt_file}


    ) &

done




##############################
## SPLIT BY CELLTYPE = N=5
##############################


# N=5

# for donor in ${DONORS[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait
#     (
#     for cell in ${CELLTYPES[@]}; do 
#          for treat in ${TREATMENTS[@]}; do 
#            barFile="${CELLTYPE_BAR_DIR}cocl2_sc_project.barcode_list.${cell}.txt"
           
#            outputFile="${OUTDIR}Treatment_celltype_Donor/${treat}__${cell}__${donor}.tagalign"
#            inputTagalign="${OUTDIR}Treatment_celltype/${treat}__${cell}.tagalign"
    
#            echo "Treatment__celltype__Donor = $treat  $cell  $Donor"
#            ${SPLIT_SCRIPT} ${inputTagalign} ${outputFile} ${barFile}
#         done
#     done

#     ) &

# done




echo "DONE!!"
exit 0
