#!/bin/bash

CELLTYPES=(CoCl2__acinar CoCl2__activated_stellate CoCl2__alpha CoCl2__alpha_1 CoCl2__alpha_2 CoCl2__alpha_3 CoCl2__alpha_4 CoCl2__beta CoCl2__beta_1 CoCl2__beta_2 CoCl2__delta CoCl2__ductal CoCl2__endothelial CoCl2__gamma CoCl2__immune CoCl2__mast CoCl2__monocyte CoCl2__quiescent_stellate CoCl2__quiescent_stellate_1 CoCl2__schwann CoCl2__stellate CoCl2__unk_stellate CoCl2__unk_stellate_2 Unt__acinar Unt__activated_stellate Unt__alpha Unt__alpha_1 Unt__alpha_2 Unt__alpha_3 Unt__alpha_4 Unt__beta Unt__beta_1 Unt__beta_2 Unt__delta Unt__ductal Unt__endothelial Unt__gamma Unt__immune Unt__mast Unt__monocyte Unt__quiescent_stellate Unt__quiescent_stellate_1 Unt__schwann Unt__stellate Unt__unk_stellate Unt__unk_stellate_2)

DONORS=(1_SAMN22997021 21167 21197 4_R413 5_HP-21310-01)

INDIR_BAR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/barcode_metadata_tables/Treatment__celltype/
INDER_TAG=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/Treatment__celltype/
OUTDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/Treatment__celltype/double_check_tagaligns/


DONOR_BAR_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/barcode_metadata_tables/Donor/
#  cocl2_sc_project.barcode_list.1_SAMN22997021.txt


N=2

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (

        for donor in ${DONORS[@]}; do 

           echo "$cell $donor"
           tagfile="${INDER_TAG}${cell}.tagalign"
           barfile="${DONOR_BAR_DIR}cocl2_sc_project.barcode_list.${donor}.txt"
           outfile="${OUTDIR}${cell}.wrong.tagalign"
           grep -v -f ${barfile} ${tagfile} > ${outfile}
  
        done
    
    ) &

done

