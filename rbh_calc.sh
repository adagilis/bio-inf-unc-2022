#!/bin/bash
#This script takes two parameters, each is a taxon id. Should return a file with aligned fastas for both.
mkdir tmp_$1_$2
cd ./tmp_$1_$2
blastn -query ../seqs_${1}/${1}.fasta -db ../seqs_${2}/${2}.fasta -outfmt 6 -max_target_seqs 1 > tmp.txt
blastn -query ../seqs_${2}/${2}.fasta -db ../seqs_${1}/${1}.fasta -outfmt 6 -max_target_seqs 1 > tmp2.txt
awk '{print $2 "\t" $1}' tmp2.txt > tmp3.txt
grep -Ff tmp3.txt tmp.txt > rbh.txt
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ../seqs_${1}/${1}.fasta > ${1}.f.fasta
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ../seqs_${2}/${2}.fasta > ${2}.f.fasta
awk -v s1=$1 -v s2=$2 'BEGIN{counter=1} {
		system("grep -A 1 \"" $2 "\" " s2 ".f.fasta >> " counter ".mfasta");
		system("grep -A 1 \"" $1 "\" " s1 ".f.fasta >> " counter ".mfasta");
		counter=counter+1}' rbh.txt

#Now make phylip files that we can calculate distances for.
for i in *.mfasta;do mafft --globalpair --maxiterate 1000 $i > "${i/mfasta/multifasta}";done

#Now calculate genetic distance for each sequence with an R script
calcDists.R

#Save the resulting comparison in parent directory
#And then clean up tmp directory

cp results.txt ../$1_$2.dists.txt
cd ..
rm -r tmp_$1_$2
