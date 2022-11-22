#!/bin/bash
directory=$1

for fq1 in ${directory}/*_R1.fastq
do

echo "this is the full path"
echo $fq1
echo "this is the basename"
name=$(basename $fq1)
echo $name
fq2=${fq1%_R1.fastq}_R2.fastq
echo $fq2
sample=${name%_R1.fastq}
echo $sample

bwa mem -t4 MN908947.fasta ${fq1} ${fq2} > ${sample}.sam
samtools sort -@4 $sample.sam -o $sample.bam 
rm $sample.sam  
samtools index $sample.bam 
ivar trim -i $sample.bam -b /home/manager/artic-ncov2019/primer_schemes/nCoV-2019/V4.1/SARS-CoV-2.scheme.bed -p ${sample}_trim.bam
samtools sort -@4 ${sample}_trim.bam -o ${sample}_trim_sort.bam  
mv ${sample}_trim_sort.bam ${sample}_trim.bam 
samtools index ${sample}_trim.bam
samtools mpileup -aa -A -d 0 -Q 0 ${sample}_trim.bam | ivar consensus -p $sample -t 0.4 

done
