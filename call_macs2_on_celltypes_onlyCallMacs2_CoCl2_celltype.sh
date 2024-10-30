#!/usr/bin/env bash


# get peak dir
# PEAK_DIR=$1
# N=$2
PEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx_v2_summitsBed/peak_calls/
N=5
celltypes=(CoCl2__acinar CoCl2__activated_stellate CoCl2__alpha_1 CoCl2__alpha_2 CoCl2__alpha_3 CoCl2__alpha_4 CoCl2__alpha CoCl2__beta_1 CoCl2__beta_2 CoCl2__beta CoCl2__delta CoCl2__ductal CoCl2__endothelial CoCl2__gamma CoCl2__immune CoCl2__mast CoCl2__monocyte CoCl2__quiescent_stellate CoCl2__schwann CoCl2__stellate CoCl2__unk_stellate Unt__acinar Unt__activated_stellate Unt__alpha_1 Unt__alpha_2 Unt__alpha_3 Unt__alpha_4 Unt__alpha Unt__beta_1 Unt__beta_2 Unt__beta Unt__delta Unt__ductal Unt__endothelial Unt__gamma Unt__immune Unt__mast Unt__monocyte Unt__quiescent_stellate Unt__schwann Unt__stellate Unt__unk_stellate)

# make sure output PEAK_DIR path ends in slash
if  [[ $PEAK_DIR != */ ]];
then
    PEAK_DIR="${PEAK_DIR}/"
fi

#file with cluster names 
# CELLTYPE_FILE="${PEAK_DIR}cluster_barcode_files/UNIQUE_CLUSTERS_LIST.txt"



# read cluster names into array from file
# readarray -t celltypes < ${CELLTYPE_FILE}


TAGALIGN_DIR="${PEAK_DIR}cluster_split_tagalign_files/"

# set output directory
OUTDIR="${PEAK_DIR}peak_calls/"

# check if output directory exists
if [ -d ${OUTDIR} ] 
then
    echo "" 
else
    mkdir ${OUTDIR}
fi



for cell in ${celltypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on    ${cell}       $dt"
    sort_tagalign_file="${TAGALIGN_DIR}${cell}.tagalign"
    outdirInner="${OUTDIR}${cell}/"
    
    if [ -d ${outdirInner} ] 
    then
        echo "" 
    else
        mkdir ${outdirInner}
    fi
    
    macs2 callpeak -t ${sort_tagalign_file} --outdir ${outdirInner} -n ${cell} -q 0.05 --nomodel --keep-dup all -g hs

    ) &

done

echo "Done!!!"
exit 0
