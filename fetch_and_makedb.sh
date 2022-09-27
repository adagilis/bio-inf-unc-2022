#!/bin/bash
mkdir seqs_$1
cd ./seqs_$1
entries=`esearch -db nucleotide -query "txid$1 AND is_nuccore[filter] AND 50:5000[SLEN]" | xtract -pattern ENTREZ_DIRECT -element Count`
sleep 0.5s
if [[ $entries -gt 10000 ]]
then
	esearch -db nucleotide -query "txid$1 AND is_nuccore[filter] AND 50:5000[SLEN]"  | efetch -format fasta -stop 10000 > ${1}.fasta
else
	esearch -db nucleotide -query "txid$1 AND is_nuccore[filter] AND 50:5000[SLEN]"  | efetch -format fasta > ${1}.fasta
fi
makeblastdb -dbtype nucl -in ${1}.fasta 
