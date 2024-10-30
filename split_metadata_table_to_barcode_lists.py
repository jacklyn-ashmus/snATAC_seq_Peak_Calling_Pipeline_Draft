#!/usr/bin/env python3
import pandas as pd
import os
import argparse


def load_clusters(clusterfilename, cluster_col):
    df = pd.read_table(clusterfilename, sep='\t', header=0, index_col=0)
    cluster_map = df[cluster_col].to_dict()
    unique_clusters = sorted(set(df[cluster_col]))
    cluster_barcode_list_dict = dict()
    for clust in unique_clusters:
        cluster_barcode_list_dict[clust] = list()
    for bar in cluster_map.keys():
        cluster_from_barcode = cluster_map[bar]
        clustlist = cluster_barcode_list_dict[cluster_from_barcode]
        clustlist.append(bar)
        cluster_barcode_list_dict[cluster_from_barcode] = clustlist    
    pass_barcodes = df.index
    return cluster_barcode_list_dict, unique_clusters, pass_barcodes

def write_barcodes_to_cluster_files (cluster_map, unique_clusters, barcodedir):
    for clust in unique_clusters:
        outfilename = barcodedir + clust + '.barcodes'
        outfile = open(outfilename, 'w')
        for bar in cluster_map[clust]:
            outfile.write(bar + '\n')
        outfile.close()
        
def make_bardir (outdir):
    if not outdir.endswith('/'):
        outdir = outdir + '/'
    bardir = outdir + 'cluster_barcode_files/'
    if not os.path.isdir(bardir):
        os.mkdir(bardir)
    return (bardir)

def write_unique_cluster_list_file (unique_clusters, bardir):
    outfilename = bardir + 'UNIQUE_CLUSTERS_LIST.txt'
    outfile = open(outfilename, 'w')
    for clust in unique_clusters:
        outfile.write(clust + '\n')
    outfile.close()



if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-c','--cluster_col', required=True, type=str, default='stdin', help="cluster column in barcode metadata file")
    parser.add_argument('-m', '--metadata_table', required=True, type=str, default='stdin', help="metadata table with cluster column and barcodes")
    parser.add_argument('-o', '--output_dir', required=True, type=str, default='stdin', help="output directory for peak calls")

    args=parser.parse_args()
    
    cluster_map1, unique_clusters1, pass_barcodes1 = load_clusters(args.metadata_table, args.cluster_col)
    barcodedir = make_bardir(args.output_dir)
    write_barcodes_to_cluster_files (cluster_map1, unique_clusters1, barcodedir)
    write_unique_cluster_list_file (unique_clusters1, barcodedir)
