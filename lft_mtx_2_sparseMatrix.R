## !/home/jnewsome/anaconda3/envs Rscript
suppressPackageStartupMessages(library(Matrix))
suppressPackageStartupMessages(library(dplyr))
suppressWarnings(suppressPackageStartupMessages(library(tictoc)))
args = commandArgs(trailingOnly=TRUE)
infile = args[1]
outfile = args[2]
celltypename = args[3]
print(paste('infile = ', infile))
print(paste('outfile = ', outfile))
print(paste('celltype = ', celltypename))
barcode_file = paste0(outfile, '.barcodes')
peaks_file = paste0(outfile, '.peaks')
tic(paste('read lft mtx = ', celltypename))
data <- read.table(infile, sep="", header=FALSE, stringsAsFactors=TRUE)
toc()

colnames(data) <- c('peak','barcode','value')
# print(head(data))
# print(dim(data))
# print(paste0('peak = ', head(levels(data$peak))))
# print(paste0('barcode = ', head(levels(data$barcode))))
# print(levels(data))
tic(paste('make sparse = ', celltypename))
sparse.data <- with(data, 
                    sparseMatrix(
                        i=as.numeric(as.factor(peak)),
                        j=as.numeric(as.factor(barcode)),
                        x=value, 
                        dimnames=list(
                                    levels(data$peak), 
                                    levels(data$barcode)
                                )
                    )
                   )            
toc()
# print(head(dimnames(sparse.data)))
# print(head(levels)
# print(paste('colnames = ',head(colnames(sparse.data))))
#       print(head(rownames(sparse.data)))
# print(paste('barcode = ', barcode_file))
# print(paste('peaks_file = ', peaks_file))
# print(head(sparse.data))
# print(paste0('cols = ', head(colnames(sparse.data))))
# print(dim(sparse.data))
# class(head(levels(data$peak)))
tic(paste('write out = ', celltypename))
t <- writeMM(sparse.data, file=outfile)

write.table(data.frame(colnames(sparse.data)), file=barcode_file, row.names=FALSE, col.names=FALSE,  quote=FALSE)
write.table(data.frame(rownames(sparse.data)), file=peaks_file, row.names=FALSE, col.names=FALSE, quote=FALSE)


toc()
                    
