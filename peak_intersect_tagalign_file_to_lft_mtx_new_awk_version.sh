#!/usr/bin/env bash

INFILE=$1
OUTFILE=$2

INFILE_INTERMED="${INFILE}.lesscol.txt"
INFILE_INTERMED2="${INFILE}.lftmtx.unsort.txt"

awk '{print $1 ":" $2 "-" $3 "\t" $14 }' "$INFILE" > "$INFILE_INTERMED"



# 1         2       3          4                   5      6           7     8       9      10       11     12      13        14                                 
# chr1    9949    10487   CoCl2__acinar_peak_1    122     .       9.43606 15.4437 12.2724 165     chr1    9919    10119   Pool2_CoCl2_PM005_PM008_CCGCACACAAATACCT-1      30      +
    
    awk '{
        combination = $1 "\t" $2
        count[combination]++
    }
    END {
        for (comb in count) {
            print comb, count[comb]
        }
    }' "$INFILE_INTERMED" > "$INFILE_INTERMED2"
    
    
    
sort -k1,1 -k2,2n  "$INFILE_INTERMED2" > "$OUTFILE"
