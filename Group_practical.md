Datasets that have been generated at the RITM have been uploaded to the training VMs in the ```Group_practicals```:
+ A metagenomic dataset using Illumina sequencing: ```metaGen_Illumina_SARS-CoV-2```, which you may want to analyse by producing a bash script that processes the file like what we did on Wednesday. This analysis might take a while especially if you decide to do de-novo asssembly. The fastq files are in ```/home/manager/Group_practicals/metaGen_Illumina_SARS-CoV-2/04Aug2022_MolDx_SARS-CoV-2_Metagenomics/Analysis/220804_M04597_0049_000000000-JK59B/Alignment_1/20220805_175123/Fastq/```
+ A whole genome assembly using Illumina: ```WGS_Illumina_SARS-CoV-2```, which you may want to explore using the methods we learnt on Tuesday. You could develop a bash script that produces consensus sequences for all the fastq files. The fastq files are in ```'/home/manager/Group_practicals/WGS_Illumina_SARS-CoV-2/220111_M04597_0039_000000000-JKV56/Alignment_1/20220113_230938/Fastq/```
+ A whole genome assembly using Oxford Nanopore Technology: ```WGS_ONT_SARS-CoV-2```. As for the Illumina, you may want to produce a piepline to automate the consensus generation. Here you will need to use the artic conda environment to run all the necessary tools.

Explore these datasets as a team: 
+ Are they amplicon? Are they shotgun? 
+ What is the quality? Trim the reads?


