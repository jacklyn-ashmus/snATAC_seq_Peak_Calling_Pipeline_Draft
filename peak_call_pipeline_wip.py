#!/usr/bin/env python3

# WRAPPER SCRIPT

import pandas as pd
import os
import argparse
import subprocess

# import os
# import sys
# import gzip
# import subprocess
# import numpy as np
# import pandas as pd
# from multiprocessing import Pool


def locate_all_necessary_scripts ():
    



def call_metadata_table_to_cluster_barcode_script (metadata_table_to_bar_py_script, cluster_column_name, metadata_table_file, peak_out_dir):
        cmd = ['python', metadata_table_to_bar_py_script, 
               '-c', cluster_column_name, 
               '-m', metadata_table_file, 
               '-o', peak_out_dir]
         subprocess.call(macs2_cmd)

def call_split_tagalign_script (splitTagalign_bashScript, peak_output_dir, n_processes, merged_tagalign_file):
    # '/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/split_tagalign_file_with_barcode_lists.sh'
    # Variables from command line input
#         MERGED_TAGALIGN_FILE=$1
#         PEAK_DIR=$2
#         N=$3
    cmd = [splitTagalign_bashScript, merged_tagalign_file, peak_output_dir, n_processes]
    subprocess.call(cmd)

    

def call_call_macs2_peaks_script ():
        print('call macs2 peaks')
        macs2_cmd = ['macs2', 'callpeak', '-t', cluster_tagalign, '--outdir', os.getcwd(), '-n', cluster_prefix, '-q', '0.05', '--nomodel', '--keep-dup', 'all', '-g', 'hs']
        with open(cluster_prefix + '.macs2_callpeak.log', 'w') as f:
                subprocess.call(macs2_cmd, stdout=f, stderr=f)

                
                
def call_count_reads_script ():
            print('get total reads', c)
        total_reads = subprocess.check_output('cat {} | wc -l'.format(cluster_tagalign2), shell=True)

        
def call_softlink_tagalign_to_bed_script ():
    
        print('bedtools genomecov', c)
        cluster_tagalign_sort = cluster_prefix + '.sort.bed'
        
def call_bedtools_genomecov_script ():
            sortcmd = ['sort', '-k1,1', '-k2,2n', cluster_tagalign2]
#         subprocess.call(['sort', '-k1,1', '-k2,2n', cluster_tagalign2])
        with open(cluster_tagalign_sort, 'w') as f:
                subprocess.call(sortcmd, stdout=f)
        genomecov_cmd = ['bedtools', 'genomecov', '-i', cluster_tagalign_sort, '-bg', '-scale', '{}'.format(1e6/int(total_reads.decode())), '-g', args.genome_file]
        with open(cluster_prefix + '.scale_1e6.bdg', 'w') as f:
                subprocess.call(genomecov_cmd, stdout=f)
        
def call_bedgraph_to_bigwig_script ():
    

        print('bedGraphToBigWig', c)
        subprocess.call(['bedGraphToBigWig', cluster_prefix + '.scale_1e6.bdg', args.genome_file, cluster_prefix + '.scale_1e6.ATAC.bw'])
        os.rename(cluster_tagalign, '{}.tagalign'.format(cluster_prefix))
        subprocess.call(['gzip', '{}.tagalign'.format(cluster_prefix)])


def call_merge_peaks_script ():
        def merge_peaks(args):
        cluster_prefix  = '{}{}'.format(args.output_prefix, c)
        output_prefix = args.output_prefix
        print('args.output_prefix = ',args.output_prefix)
        peak_files = ['{}{}_peaks.narrowPeak'.format(args.output_prefix, c) for c in args.unique_clusters]
        allpeaks_file = '{}all_peaks.anno.bed'.format(args.output_prefix)
        mergedpeaks_file = '{}merged_peaks.anno.bed'.format(args.output_prefix)
        print(peak_files)
        with open(allpeaks_file, 'w') as apf:
                for peak_file in peak_files:
                        cluster_name = peak_file.split('.')[1].split('_peaks')[0]
                        with open(peak_file) as pf:
                                for line in pf:
                                        fields = line.rstrip().split('\t')
                                        print(fields[0], fields[1], fields[2], cluster_name, sep='\t', file=apf)

        subprocess.call(['sort', '-k1,1', '-k2,2n', '-o', allpeaks_file, allpeaks_file])

        with open(mergedpeaks_file, 'w') as mpf:
                merge1 = subprocess.Popen(['bedtools', 'merge', '-i', allpeaks_file], stdout=subprocess.PIPE)
                intersect = subprocess.Popen(['bedtools', 'intersect', '-a', '-', '-b', allpeaks_file, '-wa', '-wb'], stdin=merge1.stdout, stdout=subprocess.PIPE)
                merge2= subprocess.call(['bedtools', 'merge', '-i' ,'-', '-c', '7', '-o', 'distinct'], stdin=intersect.stdout, stdout=mpf)
        return mergedpeaks_file

def call_make_celltype_specific_peak_lft_mtx_script ():
    
def call_make_celltype_specific_peak_mm_mtx_script ():
       
def call_make_merged_peak_lft_mtx_script ():
    
def call_merge_merged_peak_mm_mtx_script ():
    



















def main(args):
    
    ##### STEPS #####
    # 1. locate all the scripts
    
    # 2. double check all inputs 
    
    # 3. get lists of barcodes from metadata table, per cluster
    #         replaces load_clusters(args) function in Josh's original script
    call_metadata_table_to_cluster_barcode_script(META_TO_BAR_SCRIPT, CLUSTER_COLNAME, METADATA_TABLE_FILE, PEAK_OUT_DIR)
    # 4. split tagalign file
    #         replaces part 1 of split_reads_and_call_peaks(args, c) function in Josh's original script
    call_split_tagalign_script (SPLIT_TAGALIGN_SCRIPT, PEAK_OUT_DIR, N_PROCESSES_SPLIT, MERGED_TAGALIGN_FILE)
    # 5. call peaks
    #         replaces part 2 of split_reads_and_call_peaks(args, c) function in Josh's original script
    
    # 6  count reads in tagalign files 
            #  replaces part 3 of split_reads_and_call_peaks(args, c) function in Josh's original script
    # 7. softlink tagalign to bed file for genomecov
    # 8. call bedtools genomecov on tagalign file to get bdg
            #  replaces part 4 of split_reads_and_call_peaks(args, c) function in Josh's original script
    # 9. call bedgraph to bigwig on bdg file
           #  replaces part 5 of split_reads_and_call_peaks(args, c) function in Josh's original script
    # 10. merge all narrowpeak files to one
        # 10.a. create bed files for each narrowpeak files, annotated with cluster name
        # 10.b. write all anno bed file paths to a text file for reading into bash script
        # 10.c. loop over files, cat to single all peaks file
        # 10.d. sort 
        # 10.e. merge bed with  bedtools merge
        # 10.f. intersect with cat anno bed file
        # 10.g. bedtools merge with -c 7 column thing
    # 11. make celltype specific peak lft mtx file
    # 12. make celltype specific peak mm mtx file
    # 13. make merged peak lft mtx file
    # 14. cat merged peak lft mtx files
    # 15. sort cat'd merged peak lft mtx file
    # 16. make cat'd merged peak mm mtx file
    # 17. zip lft mtx files 
    # 18. zip mm mtx files
    # 19. delete unzipped split tagalign files
    
    
    
    # do if then skip steps here

    def main(args):
    #         args.cluster_map, args.unique_clusters, args.pass_barcodes = load_clusters(args)
    #         arglist = [(args, c) for c in args.unique_clusters]
    #             if not args.skip_split:
    #                     with Pool(processes=min(36, len(args.unique_clusters))) as pool:
    #                             pool.starmap(split_reads_and_call_peaks, arglist)
    #             if not args.skip_merge:
    #                     args.mergedpeaks_file = merge_peaks(args)
            if not args.skip_matrix:
                    if args.skip_merge:
                            args.mergedpeaks_file = '{}merged_peaks.anno.bed'.format(args.output_prefix)
                    create_peak_matrix(args)
            if args.find_marker_peaks:
                    find_marker_peaks(args)
            return



if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-c','--cluster_column', required=True, type=str, default='stdin', help="cluster column in barcode metadata file")
    parser.add_argument('-m', '--metadata_table', required=True, type=str, default='stdin', help="metadata table with cluster column and barcodes")
    parser.add_argument('-o', '--output_dir', required=True, type=str, default='stdin', help="output directory for peak calls")

    
    io_group.add_argument('-c', '--cluster-file', required=True, type=str, help='Path to cluster file')
    io_group.add_argument('-t', '--tagalign-file', required=True, type=str, help='Path to tagAlign file')
    io_group.add_argument('-n', '--cluster-col', required=False, default='cluster_name', type=str, help='Name of the cluster column')
    io_group.add_argument('-o', '--output-prefix', required=True, type=str, help='Output prefix to prepend')
    io_group.add_argument('-g', '--genome-file', required=False, default='/home/joshchiou/references/hg19.chrom.sizes', type=str, help='Output prefix to prepend')

    skip_group = parser.add_argument_group('Skip steps')
    skip_group.add_argument('--skip-split', required=False, action='store_true', default=False, help='Skip read split and peak calling step')
    skip_group.add_argument('--skip-merge', required=False, action='store_true', default=False, help='Skip peak merging step')
    skip_group.add_argument('--skip-matrix', required=False, action='store_true', default=False, help='Skip peak matrix generation step')
    skip_group.add_argument('--find-marker-peaks', required=False, action='store_true', default=False, help='Find marker peaks for each cluster')
    
    scripts_group = parser.add_argument_group('Hard paths to scripts. use if scripts can\'t automatically be located. ')
    scripts_group.add_argument('--make_barcode_list_script', required=False,  type=str, help='Path to cluster file', 
                               default='/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/split_metadata_table_to_barcode_lists.py')
    scripts_group.add_argument('--split_tagalign_script', required=False, type=str, help='Path to cluster file', 
                               default='/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/split_tagalign_file_with_barcode_lists.sh')
    scripts_group.add_argument('--skip-split', required=False,  type=str, help='Path to cluster file')
    scripts_group.add_argument('--skip-split', required=False,  type=str, help='Path to cluster file')
    scripts_group.add_argument('--skip-split', required=False,  type=str, help='Path to cluster file')
    scripts_group.add_argument('--skip-split', required=False,  type=str, help='Path to cluster file')
    scripts_group.add_argument('--skip-split', required=False,  type=str, help='Path to cluster file')
    scripts_group.add_argument('--skip-split', required=False,  type=str, help='Path to cluster file')
    
    
    args=parser.parse_args()
    
    
    
    
    
    
    
    cluster_map1, unique_clusters1, pass_barcodes1 = load_clusters(args.metadata_table, args.cluster_col)
    barcodedir = make_bardir(args.output_dir)
    write_barcodes_to_cluster_files (cluster_map1, unique_clusters1, barcodedir)
    write_unique_cluster_list_file (unique_clusters1, barcodedir)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ################ old stuff ########################
    
    
    
   



def create_peak_matrix(args):
    
        for c in args.unique_clusters:
            cluster_prefix  = '{}{}'.format(args.output_prefix, c)
            peak_files = '{}{}_peaks.narrowPeak'.format(args.output_prefix, c)
            cluster_tagalign_sort = cluster_prefix + '.sort.bed'
            mergedpeaks_file = '{}merged_peaks.anno.bed'.format(args.output_prefix)
            lfmatrix_file = '{}.lf_mtx.gz'.format(cluster_prefix)
            mtx_file = '{}.mtx'.format(cluster_prefix)
            barcodes_file = '{}.barcodes'.format(cluster_prefix)
            peaks_file = '{}.peaks'.format(cluster_prefix)

            tmp_R = '{}.tmp.R'.format(cluster_prefix)
            
            print('lfmatrix_file = ', lfmatrix_file)
            intersect = subprocess.Popen(['bedtools', 'intersect', '-a', args.mergedpeaks_file, '-b', args.tagalign_file, '-wa', '-wb', '-sorted'], stdout=subprocess.PIPE)
            with gzip.open(lfmatrix_file, 'wt') as lf:
                    for line in intersect.stdout:
                            fields = line.decode().rstrip().split('\t')
                            print('{}:{}-{}\t{}'.format(fields[0].replace('chr',''), fields[1], fields[2], fields[7]), file=lf)
            lfm = pd.read_table(lfmatrix_file, sep='\t', header=None, names=['peak','cell'])
#             lfm = lfm.loc[lfm['cell'].isin(args.pass_barcodes)]
            lfm = lfm.groupby(lfm.columns.tolist()).size().reset_index().rename(columns={0:'value'})
            lfm.to_csv(lfmatrix_file, sep='\t', index=False, compression='gzip')


            with open(tmp_R, 'w') as tR:
                    print('''library(Matrix)''', file=tR)
                    print('''data <- read.table('{}', sep='\\t', header=TRUE)'''.format(lfmatrix_file), file=tR)
                    print('''sparse.data <- with(data, sparseMatrix(i=as.numeric(as.factor(peak)), j=as.numeric(as.factor(cell)), x=value, dimnames=list(levels(peak), levels(cell))))''', file=tR)
                    print('''t <- writeMM(sparse.data, '{}')'''.format(mtx_file), file=tR)
                    print('''write.table(data.frame(colnames(sparse.data)), file='{}', col.names=FALSE, row.names=FALSE, quote=FALSE)'''.format(barcodes_file), file=tR)
                    print('''write.table(data.frame(rownames(sparse.data)), file='{}', col.names=FALSE, row.names=FALSE, quote=FALSE)'''.format(peaks_file), file=tR)
            subprocess.call(['Rscript', tmp_R])
            subprocess.call(['gzip', mtx_file])
            os.remove(tmp_R)
        return

def find_marker_peaks(args):
        import scipy.io
        import statsmodels.api as sm

        clusters = pd.read_table(args.cluster_file, sep='\t', header=0, index_col=0)
        mtx = scipy.io.mmread('{}.mtx.gz'.format(args.output_prefix)).tocsr()
        barcodes = open('{}.barcodes'.format(args.output_prefix)).read().splitlines()
        peaks = open('{}.peaks'.format(args.output_prefix)).read().splitlines()
        zscores = pd.DataFrame(columns=sorted(set(clusters[args.cluster_col])))
        chunks = np.arange(0, mtx.shape[0], 10000)
        chunks = np.append(chunks, mtx.shape[0])
        for i in range(len(chunks)-1):
                z = pd.DataFrame(columns=sorted(set(clusters[args.cluster_col])))
                dmtx = pd.DataFrame(mtx[chunks[i]:chunks[i+1],:].todense(), columns=barcodes, index=peaks[chunks[i]:chunks[i+1]])
                dmtx = (dmtx > 0).astype(int)
                for cluster in sorted(set(clusters[args.cluster_col])):
                        label_cov = clusters.copy().loc[dmtx.columns]
                        label_cov['OvR'] = [1 if c==cluster else -1 for c in label_cov[args.cluster_col]]
                        label_cov = label_cov[['OvR'] + ['log_usable_counts']]
                        label_cov = sm.add_constant(label_cov)
                        z[cluster] = dmtx.apply(lambda x: sm.Logit(x, label_cov.values).fit().tvalues[1] if sum(x[dmtx.columns.isin(label_cov.loc[label_cov['OvR']==1].index)])>0 else np.nan, axis=1)
                zscores = zscores.append(z)
        zscores.to_csv('{}.logit_zscores.txt'.format(args.output_prefix), sep='\t', header=True, index=True, float_format='%.4f')
        return

def main(args):
#         args.cluster_map, args.unique_clusters, args.pass_barcodes = load_clusters(args)
#         arglist = [(args, c) for c in args.unique_clusters]
#         if not args.skip_split:
#                 with Pool(processes=min(36, len(args.unique_clusters))) as pool:
#                         pool.starmap(split_reads_and_call_peaks, arglist)
#         if not args.skip_merge:
#                 args.mergedpeaks_file = merge_peaks(args)
        if not args.skip_matrix:
                if args.skip_merge:
                        args.mergedpeaks_file = '{}merged_peaks.anno.bed'.format(args.output_prefix)
                create_peak_matrix(args)
        if args.find_marker_peaks:
                find_marker_peaks(args)
        return

def process_args():
        parser = argparse.ArgumentParser(description='Call peaks for each cluster from snATAC-seq data')
        io_group = parser.add_argument_group('I/O arguments')
        io_group.add_argument('-c', '--cluster-file', required=True, type=str, help='Path to cluster file')
        io_group.add_argument('-t', '--tagalign-file', required=True, type=str, help='Path to tagAlign file')
        io_group.add_argument('-n', '--cluster-col', required=False, default='cluster_name', type=str, help='Name of the cluster column')
        io_group.add_argument('-o', '--output-prefix', required=True, type=str, help='Output prefix to prepend')
        io_group.add_argument('-g', '--genome-file', required=False, default='/home/joshchiou/references/hg19.chrom.sizes', type=str, help='Output prefix to prepend')

        skip_group = parser.add_argument_group('Skip steps')
        skip_group.add_argument('--skip-split', required=False, action='store_true', default=False, help='Skip read split and peak calling step')
        skip_group.add_argument('--skip-merge', required=False, action='store_true', default=False, help='Skip peak merging step')
        skip_group.add_argument('--skip-matrix', required=False, action='store_true', default=False, help='Skip peak matrix generation step')
        skip_group.add_argument('--find-marker-peaks', required=False, action='store_true', default=False, help='Find marker peaks for each cluster')
        return parser.parse_args()

if __name__ == '__main__':
        logging.basicConfig(format='[%(filename)s] %(asctime)s %(levelname)s: %(message)s', datefmt='%I:%M:%S', level=logging.DEBUG)
        args = process_args()
        print(args)
        print('\n\n')
        
        main(args)
