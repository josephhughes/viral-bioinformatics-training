#!/bin/bash

#declare -a SAMPLE_LIST=(ERR9105817 ERR9731990 ERR9761275 ERR9788433)

DIRECTORY=$1

cp /home/manager/SARS-CoV-2/MN908947.fasta .

bwa index MN908947.fasta 

touch report.txt

for i in ${DIRECTORY}/*_R1.fastq
do
file_name=$(basename $i)
echo "==================================================="
echo "==========STARTING BWA PROCESS====================="
echo "==================$file_name======================="
echo "==================================================="

bwa mem -t4 MN908947.fasta $i ${i%_R1.fastq}_R2.fastq > $file_name.sam

echo "=================================================="
echo "==============END BWA PROCESS====================="
echo "=================================================="

echo "=================================================="
echo "==========SORTING AND INDEXING PROCESS============"
echo "=================================================="
samtools sort -@4 $file_name.sam -o $file_name.bam
rm $file_name.sam


echo "=================================================="
echo "============TRIMMING  PROCESS====================="
echo "=================================================="
samtools index $file_name.bam
ivar trim -i $file_name.bam -b /home/manager/artic-ncov2019/primer_schemes/nCoV-2019/V4.1/SARS-CoV-2.scheme.bed -p "$file_name"_trim.bam
samtools sort -@4 "$file_name"_trim.bam -o "$file_name"_trim_sort.bam
mv "$file_name"_trim_sort.bam "$file_name"_trim.bam

echo "=================================================="
echo "================FINISHING THINGS UP==============="
echo "=================================================="
samtools mpileup -aa -A -d 0 -Q 0 "$file_name"_trim.bam | ivar consensus -p "$file_name" -t 0.4 >> report.txt

echo "=================================================="
echo "=================DONE! $file_name ================"
echo "=================================================="
done

