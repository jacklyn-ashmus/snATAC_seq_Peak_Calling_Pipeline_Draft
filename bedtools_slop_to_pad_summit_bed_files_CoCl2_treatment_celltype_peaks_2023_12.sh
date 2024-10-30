#!/usr/bin/env bash

# SUMMITDIR=$1
# FIXED_PEAK_DIR=$2
SUMMITDIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/normal_peaks/treatment_celltype/peaks/summits_bed/
FIXED_PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/fixed_peaks/treatment_celltype/REDO/peaks/
PAD_SIZE=200
PAD_SIZE_2=$(( 2*PAD_SIZE ))
PAD_SIZE_R=$(( PAD_SIZE-1 ))
GENOME_SIZE=/nfs/lab/ref/hg38.chrom.sizes
n=6
celltypes=(CoCl2__acinar CoCl2__activated_stellate CoCl2__alpha_1 CoCl2__alpha_2 CoCl2__alpha_3 CoCl2__alpha_4 CoCl2__alpha CoCl2__beta_1 CoCl2__beta_2 CoCl2__beta CoCl2__delta CoCl2__ductal CoCl2__endothelial CoCl2__gamma CoCl2__immune CoCl2__mast CoCl2__monocyte CoCl2__quiescent_stellate CoCl2__schwann CoCl2__stellate CoCl2__unk_stellate Unt__acinar Unt__activated_stellate Unt__alpha_1 Unt__alpha_2 Unt__alpha_3 Unt__alpha_4 Unt__alpha Unt__beta_1 Unt__beta_2 Unt__beta Unt__delta Unt__ductal Unt__endothelial Unt__gamma Unt__immune Unt__mast Unt__monocyte Unt__quiescent_stellate Unt__schwann Unt__stellate Unt__unk_stellate)

# celltypes=(alpha alpha_1 alpha_2 alpha_3 alpha_4 stellate beta beta_1 beta_2 ductal delta acinar immune gamma endothelial schwann activated_stellate    unk_stellate quiescent_stellate monocyte mast)




N=6

for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "working on    ${cell}       $dt"
    #     infile="${SUMMITDIR}${cell}/${cell}_summits.bed"
        infile="${SUMMITDIR}${cell}_summits.bed"
        outfile="${FIXED_PEAK_DIR}${cell}.fixed_peaks.${PAD_SIZE_2}bp.bed"

        bedtools slop -i ${infile} -g ${GENOME_SIZE} -l ${PAD_SIZE} -r ${PAD_SIZE_R} > ${outfile} 
        
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "done with   ${cell}       $dt"
        echo ""
   
    ) &

done


exit 0
