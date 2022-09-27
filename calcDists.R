#!/usr/bin/env Rscript

library(ape)

files = list.files(pattern="*.multifasta")
dists = matrix(nrow=length(files),ncol=3)
for(f in 1:length(files)){
	dna = read.dna(files[f],format="fasta")
	dists[f,1] = dist.dna(dna,model="raw")[1]
	dists[f,2] = dist.dna(dna,model="JC")[1]
	dists[f,3] = dist.dna(dna,model="BH87")[1]
	
}

ret = c(apply(dists,2,mean,na.rm=TRUE),length(files))

write.table(ret,file="results.txt",quote=FALSE,row.names=FALSE,col.names=FALSE)
