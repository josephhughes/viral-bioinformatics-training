# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines
* Practical adapted from [Richard Orton's tutorial](https://github.com/WCSCourses/ViralBioinfAsia2022/blob/main/Modules/SARS-CoV-2.md) 

## Contents

* [1: SARS-CoV-2 Reference Alignment](#1-sars-cov-2-reference-alignment)
	+ [1.1: Illumina shotgun Tutorial](#11-minion-tutorial)
		+ [1.1.1: Setup and Data](#111-setup-and-data)
		+ [1.1.2: Consensus sequence generation walkthrough](#112-consensus-sequence-generation-walkthrough)
		+ [1.1.3: Exercise: Generating consensus sequences yourself](#113-exercise-generating-consensus-sequences-yourself)
		+ [1.1.4: Additional Resources](#114-additional-resources)
	+ [1.2: MinION Amplicon Tutorial](#12-minion-tutorial)
		+ [1.2.1: Setup and Data](#121-setup-and-data)
		+ [1.2.2: ARTIC consensus sequence generation walkthrough](#122-artic-consensus-sequence-generation-walkthrough)
		+ [1.2.3: Exercise: Generating ARTIC consensus sequences yourself](#123-exercise-generating-artic-consensus-sequences-yourself)
		+ [1.2.4: Additional Resources](#124-additional-resources)
	+ [1.3: Illumina Amplicon Tutorial](#13-illumina-tutorial)
		+ [1.3.1: Setup and data](#131-setup-and-data)
		+ [1.3.2: Illumina consensus generation walkthrough](#132-illumina-consensus-generation-walkthrough)
		+ [1.3.3: Exercise: Generating Illumina consensus sequences yourself](#133-exercise-generating-illumina-consensus-sequences-yourself)

## 1: SARS-CoV-2 Reference Alignment

In this practical we will be performing reference alignment of SARS-CoV-2 (Severe acute respiratory syndrome coronavirus 2) samples to create consensus sequences for a number of samples. This will be done for both MinION and Illumina data sets using a different approaches (shotgun versus amplicon).

A quick reminder of useful terminal commands: navigating through folders using ```cd```, list folder contents using ```ls```, making directories using ```mkdir```, deleting files using ```rm```, entering bioinformatics commands using **TAB Completion** makes entering long filenames and paths easier.

During the presentation, you have learnt about the FASTQ format, SAM and BAM files. In this practical, you will learn: how to align illumina reads to reference sequences to call a consensus sequence; how to adapt this for handling the large number of overlapping amplicons used in the ARTIC SARS-CoV-2 protocols, and using a consensus caller specifically designed for viral samples; how to apply a similar approach to illumina amplicon data.

Commands that you need to enter into the terminal are presented in this tutorial in grey code boxes like this:

```
cd  dont_enter_this_command_its_just_an_example
```
**NB:** commands are presented within code blocks - some are long and stretch off the page within a scrollpane.

## 1.1: Illumina shotgun
In shotgun sequencing, the reads are randomly sheared into different size using either an enzyme or by vibration. This results in a number of short fragments that are subsequently sequenced using Illumina.
In most cases, you need sufficient starting material to achieve this. Here we will use as an example, SARS2 that has been cultured up in Vero cells before sequencing.


We will first create a new directory and be working in this directory for processing the standard shotgun Illumina data:

```
mkdir Ref_tutorial
```

```
cd Ref_tutorial
```

Now we are going to link to the files with the reads. This is like creating an alias in Windows. The files will appear to be in your local directory but they are actually still in their original location:

```
ln -s /home/manager/GECO_course_data/Reference_alignment/*.fastq .
```

**Task:** There are other files in `home/manager/GECO_course_data/Reference_alignment`, creat soft links to those files too.

### 1.1.1: Preparing your reads for mapping
We start by trimming and quality checking the reads:
```
trim_galore -q 25 --length 50 --paired Vero_SARS2_R1.fastq Vero_SARS2_R2.fastq
```

Breaking this command down:

* **--q 25** = trim the 3' end of the reads remove nucleotides less
than Phred Quality 25
* **--length 50** = after adapter and quality trimming, remove reads less than 50bp in length
* **--paired** = the names of the paired fastq files to analyze in order (Read 1 then Read 2)

### 1.1.2: Aligning your reads to a reference genome with BWA

There are many tools available to align reads onto a reference sequence:
BWA, Novoalign, bowtie2, STAR to name but a few. In this practical, we
will be using BWA ([http://bio-bwa.sourceforge.net]).

BWA (Burrows--Wheeler aligner) is a commonly used software designed to
map sequence reads to a reference genome. BWA actually has three
variations: BWA-backtrack (Li and Durbin, 2009), BWA-SW (Li and Durbin,
2010) and BWA-MEM (Li, 2013). In this exercise, we will be using
BWA-MEM, which is typically preferred for longer reads due to its speed
and accuracy.

To get started, let's start by indexing the reference genome:

```
bwa index MN908947.fasta
```

Now you should have some additional files in the directory along with your reference fasta file if you do ```ls MN908947*```:

* ~/SARS-CoV-2/MN908947.fasta.amb
* ~/SARS-CoV-2/MN908947.fasta.ann
* ~/SARS-CoV-2/MN908947.fasta.bwt
* ~/SARS-CoV-2/MN908947.fasta.pac
* ~/SARS-CoV-2/MN908947.fasta.sa
* ~/SARS-CoV-2/MN908947.fasta

Now let's align the samples to our reference genome using bwa mem.
Alignment is just one single step with **bwa mem**:

```
 bwa mem MN908947.fasta Vero_SARS2_R1_val_1.fq Vero_SARS2_R2_val_2.fq > Vero_SARS2.sam
```

### 1.1.3: Manipulating your SAM file with SAMtools

SAMtools is a library and software package for parsing and manipulating
alignments in the SAM/BAM format. It is a multifunctional set of tools
that is able to convert from other alignment formats, sort and merge
alignments, remove PCR duplicates, generate per-position information in
the pileup format.

If you check your directory again, you should now see a file called
**Vero_SARS2.sam**

This is an example of a "SAM" file, which is the common output file type
for deep sequencing reads. SAM files tend to take up a lot of space on
your computer however so let's go ahead and convert this file to a "BAM"
file, which is the compressed version. We will be using SAMtools to do
this:

```
  samtools view -bS Vero_SARS2.sam > Vero_SARS2_unsorted.bam
```

In this command, we are telling **SAMtools** to **view** the file
**Vero_SARS2.sam** and direct (**\>**) the output into a file called
**Vero_SARS2_unsorted.bam**. The **--bS** tells samtools that we want the
output in BAM format (**b**) and to auto-detect the format the input
data is in (**S**).

To prepare our new .bam file for downstream use, we should now sort and
index it using **SAMtools**:

```
samtools sort Vero_SARS2_unsorted.bam -o Vero_SARS2.bam
```
```
samtools index Vero_SARS2.bam
```
```
rm Vero_SARS2.sam
```
```
rm Vero_SARS2_unsorted.bam
```

In this set of commands, we are using **SAMtools** to sort the BAM
file **Vero\_SARS2_unsorted.bam** and output (**-o**) a new file called
**Vero_SARS2.bam**. We are then using **samtools** to index the BAM file
**Vero_SARS2.bam** - indexing enables faster searches downstream and
requires the data to be sorted. Finally, since we no longer need our
original uncompressed SAM file and unsorted BAM file and we don't
want to tie up our server with unneeded files, we then use the **rm**
command to remove the original **Vero_SARS2.sam** file and the old
unsorted **Vero\_SARS2_unsorted.bam** file. **Do be careful when using the ```rm``` command though, once you delete a file this way it is gone forever!**

There should now be two additional files in your directory: **Vero_SARS2.bam** (the BAM file) and **Vero_SARS2.bam.bai** (the BAM index file). To check this and to view the sizes of the files you can use:
```
ls -lh
```

The **-l** modifier of this command will list your files in the long
list format while the **-h** modifier will output the file sizes in a
human readable format.


### 1.1.4: Extracting statistics from your SAM/BAM file with SAMtools

One common thing to check is how many reads have aligned to the
reference, and how many did not. Samtools can report this for us easily:

**Number of mapped reads**:
```
samtools view -c -F4 Vero_SARS2.bam
```

An explanation of this command is as follows:

* ```samtools view``` to view the file Vero_SARS2.bam
* **--c** = count the read alignments
* **--F4** = skip read alignments that have the unmapped Flag 4

**Number of unmapped reads**:
```
samtools view -c -f4 Vero_SARS2.bam
```

This time we use **--f4** = only include read alignments that do have the
unmapped flag 4

Let the facilitators know what numbers you got, we will discuss the differences observed between people. 

Another way you can get these data is to use:

```
samtools idxstats Vero_SARS2.bam
```

This should give you the mapped and unmapped data with a single command.

Finally, we can also dig deeper into the data to look at insert size
length, number of mutations and overall coverage by creating a stats
file:

```
samtools stats Vero_SARS2.bam > Vero_SARS2_stats.txt
```

The first section of this file is a summary of the aligned data set
which can give you an idea of the quality of your data set and overall
alignment. If you open the file you just made (e.g. ```nano Vero_SARS2_stats.txt```, you should be able to
look through complete the numbers for:

SN raw total sequences: 

SN last fragments: 

SN reads mapped: 

SN reads mapped and paired: 

SN average length: 

SN maximum length: 

SN average quality: 

SN insert size average: 

SN insert size standard deviation: 


### 1.1.5: Generating the consensus with SAMtools and ivar


```
samtools mpileup -aa -A -d 0 -Q 0 Vero_SARS2.bam | ivar consensus -p Vero_SARS2 -t 0.4
```
Breaking this command down, there are two parts:

1. samtools [mpileup](http://www.htslib.org/doc/samtools-mpileup.html) which essentially outputs the base and indel counts for each genome position
	* **-aa** = output data for absolutely all positions (even zero coverage ones)
	* **-A** = count orphan reads (reads whose pair did not map)
	* **-d 0** = override the maximum depth (default is 8000 which is typically too low for viruses)
	* **-Q 0** = minimum base quality, 0 essentially means all the data
2. ivar [consensus](https://andersen-lab.github.io/ivar/html/manualpage.html) - this calls the consensus - the output of the samtools mpileup command is piped `|` directly into ivar
	* **-p CVR2058** = prefix with which to name the output file
	* **-t 0.4** = the minimum frequency threshold that a base must match to be used in calling the consensus base at a position. In this case, an ambiguity code will be used if more than one base is > 40% (0.4). See [ivar manual]

By default, ivar consensus uses a minimum depth (**-m**) of 10 and a minimum base quality (**-q**) of 20 to call the consensus; these defaults can be changed by using the appropriate arguments. If a genome position has a depth less than the minimum, an 'N' base will be used in the consensus sequence by default.


## 1.2: MinION Tutorial
This MinION tutorial is largely based on the [ARTIC](https://artic.network) network's [nCoV-2019 bioinformatics protocol](https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html) which we will use to create consensus genome sequences for a number of MinION SARS-CoV-2 samples. 

### 1.2.1: Setup and Data

The 'artic-ncov2019' [Conda](https://docs.conda.io/en/latest/) environment has already been installed on the [VirtualBox](https://www.virtualbox.org) Ubuntu virtual machine (VM) that you are using for this course, but we need to 'activate' the artic-ncov2019 Conda environment each time we want to use the ARTIC pipeline:

```
conda activate artic-ncov2019
```

Next, lets explore the output from a run:

```
ls /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/

```

**NB:** Using **TAB completion** makes navigating into long folder names easy!!

This run was performed on an [Oxford Nanopore Technologies](https://nanoporetech.com) (ONT) GridION machine, the run was started on 29th December 2020 at 15:42 (20201229_1542), using the first (X1) of the five flow cells slots on the GridION, the flowcell ID number was FAO14190, and the run was named 'Batch124A' locally within the [Medical Research Council-University of Glasgow Centre for Virus Research](https://www.gla.ac.uk/research/az/cvr/) (CVR) as part of a Covid-19 Genomics UK Consortium ([COG-UK](https://www.cogconsortium.uk)) sequencing run. The samples were sequenced used Version 2 (V2) of the ARTIC [nCoV-2019](https://github.com/artic-network/primer-schemes/tree/master/nCoV-2019) amplicon primers.

The run was live basecalled and demultiplexed using the ONT basecaller Guppy (this is available for download from the [ONT website](https://nanoporetech.com) after registration with ONT), making use of the GridION's onboard Graphical Processing Unit (GPU). If you list the contents of this directory you should see a number of files and folders:


The key files and folders in this run folder are (amongst others):

* **fast5\_pass** - this folder contains all the raw FAST5 reads that PASSED the basic quality control filters of the guppy basecaller. 
* **fast5\_fail** - this folder contains all the raw FAST5 reads that FAILED the basic quality control filters of the guppy basecaller
* **fastq\_pass** - this folder contains all the FASTQ reads that were converted from the those within the fast5\_pass fiolder
* **fastq_fail**- this folder contains all the FASTQ reads that were converted from the those within the fast5\_fail fiolder
* **sequencing\_summary\_FAO14190\_ad60b376.txt** - this sequencing_summary file is produced by the basecaller and contains a summary of each read such as it's name, length, barcode and what FAST5 and FASTQ files it is located in.

**NB:** To save disk space on the VM, the fast5\_fail and fastq\_fail folders do not contain any read data, as failed reads are not used in the pipeline.

As the data has already been demultiplexed, there is one folder for each barcode detected on the run:

```
ls /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/fastq_pass
```

You should see the following barcode folders (06, 07 and 12) representing the 3 samples on the run that we will be analysing:

* **barcode06**
* **barcode07**
* **barcode12**
* **unclassified**

**NB**: unclassified is where reads whose barcode could not be determined are placed - to save disk space on the VM there are no reads in the unclassified folders, but they typically contain substantial amounts of reads.

Typically the FASTQ data for each sample is stored in multiple files of around 4000 reads each. For barcode06, you should see 25 different FASTQ files, numerically labelled at the end of their filename from 0 to 24:

```
ls /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/fastq_pass/barcode06
```


### 1.2.2: ARTIC consensus sequence generation walkthrough

The first sample we will be working with is barcode06. The ARTIC bioinformatics protocol has two distinct steps:

1. **artic guppyplex** - combines all a samples FASTQ reads into a single file and size filters them (it can also perform a quality score check, which is not needed here as the reads are already split into pass and fail folders based on quality by guppy)
2. **artic minion** - aligns the reads to the [Wuhan-Hu-1](https://www.ncbi.nlm.nih.gov/nuccore/MN908947) reference sequence, trims the amplicon primer sequences from the aligned reads, downsamples amplicons to reduce the data, and creates a consensus sequence utilising [nanopolish](https://github.com/jts/nanopolish) for variant calling to correct for common MinION errors (such as those associated with homopolymer regions).

First we will create a folder to work in and store our output files:

```
mkdir MinION_Results
```

Then we will move into the folder to work:

```
cd MinION_Results
```

**artic guppyplex** - now we will run artic guppyplex on sample barcode06:

```
artic guppyplex --skip-quality-check --min-length 400 --max-length 700 --directory /home/manager/SARS-CoV-2/MinION//20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/fastq_pass/barcode06 --prefix cvr124a
```

Breaking this command down:

* **artic gupplyplex** = the name of the program/module to use (installed as part of conda environment)
* **--skip-quality-check** = don't filter reads based on quality (our reads are already filtered)
* **--min-length 400** = minimum read length to accept is 400 bases
* **--max-length 700** = maximum read length to accept is 700 bases
* **--directory** = PATH to input directory containing FASTQ reads to process
* **--prefix** = output name prefix to label output file (I choose cvr124a to signify batch 124a from the CVR)

This should create an output FASTQ file called **cvr124a_barcode06.fastq**:

```
ls
```

**artic minion** - next we will run artic minion using the FASTQ file created above:


```
artic minion --normalise 200 --threads 4 --scheme-directory /home/manager/artic-ncov2019/primer_schemes --read-file cvr124a_barcode06.fastq --fast5-directory /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/fast5_pass/barcode06 --sequencing-summary /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/sequencing_summary_FAO14190_ad60b376.txt nCoV-2019/V2 barcode06
```

Breaking this command down:

* **artic minion** = the name of the program/module to use (installed as part of conda environment)
* **--normalise 200** = normalise (downsample) each amplicon so there are only 200 reads in each direction (forward and reverse) - this enables the nanopolish variant and consensus calling to complete relatively quickly
* **--threads 4** = the number of computer threads to use (depends on how powerful your machine is, the more the better)
* **--scheme-directory** = path to the artic primer scheme directory (installed on the VM as part of the conda environment)
* **--read-file** = the name of the input FASTQ file to align
* **--fast5-directory** = the path to the corresponding FAST5 folder of the reads
* **--sequencing-summary** = the path to the sequencing_summary.txt file of the run 
* **nCoV-2019/V2** = the primer scheme to use for amplicon primer trimming - this folder is located in the scheme\_directory so on this VM this corresponds to the folder ~/artic-ncov2019/primer_schemes/nCoV-2019/V2
* **barcode06** = the output prefix name to label output files, this can be anything you want such as the sample name or barcode number or anything you want

Overall, this artic minion command uses the aligner [minimap2](https://github.com/lh3/minimap2) to align the reads to the [Wuhan-Hu-1](https://www.ncbi.nlm.nih.gov/nuccore/MN908947) reference sequence, [samtools](http://www.htslib.org) to convert and sort the SAM file into BAM format, custom [artic](https://github.com/artic-network/fieldbioinformatics) scripts for amplicon primer trimming and normalisation (downsampling), [nanopolish](https://github.com/jts/nanopolish) for variant calling, and custom [artic](https://github.com/artic-network/fieldbioinformatics) scripts for creating the consensus sequence using the reference and VCF files, and then masking low coverage regions with Ns. This will create the following key files (amongst many others), all starting with the prefix **barcode06** in this instance:

* **barcode06.sorted.bam** - BAM file containing all the reads aligned to the reference sequence (there is no amplicon primer trimming in this file)
* **barcode06.trimmed.rg.sorted.bam** - BAM file containing normalised (downsampled) reads with amplicon primers left on - this is the file used for variant calling
* **barcode06.primertrimmed.rg.sorted.bam** - BAM file containing normalised (downsampled) reads with amplicon primers trimmed off
* **barcode06.pass.vcf.gz** - detected variants that PASSed the filters in VCF format (gzipped)
* **barcode06.fail.vcf** - detected variants that FAILed the filters in VCF format
* **barcode06.consensus.fasta** - the consensus sequence of the sample

**NB:** this command will give a warning message at the end, this can be ignored as we don't need the muscle alignment file. The warning is due to an updated version of muscle within the artic environment that expects the command structured -align and -output rather than -in and -out (also reported as a GitHub issue [here](https://github.com/artic-network/artic-ncov2019/issues/93)):

```
#DO NOT ENTER THIS - IT IS A RECORD OF THE ERROR MESSAGE
Command failed:muscle -in barcode06.muscle.in.fasta -out barcode06.muscle.out.fasta
```

We can count the number of reads that have mapped to the reference sequence (discounting supplementary and additional alignments which are multi-mappings) using samtools view with the -c argument to count reads, and by utilising [SAM Flags](https://samtools.github.io/hts-specs/SAMv1.pdf) to only count read alignments that are mapped (F4), that are primary alignments (F256), and are not supplementary alignments (F2048): F4 + F256 + F2048 = F2308:

```
samtools view -c -F2308 barcode06.sorted.bam
```

**NB:** Alternatively, you could use the command ```samtools flagstats barcode06.sorted.bam``` .

If you compare the mapped read count to that from the normalised (downsampled) BAM file, you should see less mapped reads due to the normalisation step:

```
samtools view -c -F2308 barcode06.trimmed.rg.sorted.bam
```

We can view the FASTA consensus sequence via the command line:

```
more barcode06.consensus.fasta
```

### 1.2.3: Exercise: Generating ARTIC consensus sequences yourself

Your task now is to adapt the above artic guppyplex and minion commands to run on samples barcode07 and/or barcode12.

A reminder of the two commands used for barcode06 is:


```
artic guppyplex --skip-quality-check --min-length 400 --max-length 700 --directory /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/fastq_pass/barcode06 --prefix cvr124a
```

```
artic minion --normalise 200 --threads 4 --scheme-directory ~/artic-ncov2019/primer_schemes --read-file cvr124a_barcode06.fastq --fast5-directory /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/fast5_pass/barcode06 --sequencing-summary /home/manager/SARS-CoV-2/MinION/20201229_1542_X1_FAO14190_c9e59aa7_Batch124A/sequencing_summary_FAO14190_ad60b376.txt nCoV-2019/V2 barcode06
```

Essentially all you will need to do is change every occurrence of **barcode06** (once in guppyplex and three times in minion) to either **barcode07** or **barcode12**. 

**QUESTION** - what is number of mapped reads in each of the samples you have looked at?

As the commands are well structured and all that is needed to change is the input and output names within a run, it means that these commands are easily scriptable using bash (which you have learnt earlier on in this course) or pipeline tools such as [snakemake](https://snakemake.github.io) and [nextflow](https://www.nextflow.io).

At the end of this session we should deactivate our conda environment:

```
conda deactivate
```

### 1.2.4: Additional Resources


We were initially planning on using the [ncov2019-artic-nf](https://github.com/connor-lab/ncov2019-artic-nf) nextflow pipeline for running the ARTIC network tools as it offers a number of extra functions and easier automation. However, we could not get it working on the VM correctly (DSL error resolved by replacing nextflow.preview.dsl = 2 with nextflow.enable.dsl = 2 within the scripts, but the following error could not be resolved by dropping down Nextflow versions (GitHub issue to be created):

```
Unqualified output value declaration has been deprecated - replace `tuple sampleName,..` with `tuple val(sampleName),..`
```

We did also try using the [nf-core/viral-recon](https://nf-co.re/viralrecon) viral nextflow pipeline, which is highly recommended (not just for SARS-CoV-2), but performance was not great on our small VM.

There is a very nice [SARS-CoV-2 sequencing data analysis tutorial](https://github.com/cambiotraining/sars-cov-2-genomics) created by CamBioTraining, which includes [nf-core/viral-recon](https://nf-co.re/viralrecon) instructions.

This MinION tutorial is based on the original [ARTIC](https://artic.network) network's [nCoV-2019 bioinformatics protocol](https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html).

## 1.3: Illumina Tutorial

In the above tutorial, we were working with MinION data. In this tutorial we will be using paired end Illumina SARS-CoV-2 data. Although this uses different computational tools, the two approaches are in essence very similar.

### 1.3.1: Setup and data

We do not need to use a conda environment as all the tools we need are already installed directly on the VM: 

* [trim_galore](https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/) for read trimming (the reads are pre-trimmed using trim_galore)
* [bwa](https://github.com/lh3/bwa) for read alignment
* [samtools](http://www.htslib.org) for SAM/BAM conversion
* [ivar](https://andersen-lab.github.io/ivar/html/manualpage.html) for primer trimming and consensus calling
* [weeSAM](https://github.com/centre-for-virus-research/weeSAM) for coverage plots.

First, lets look at the Illumina data directory:

```
ls /home/manager/SARS-CoV-2/Illumina/200703_M01569_0148_000000000-J53HN_Batch70/
```

The data in this folder is from a run on an Illumina MiSeq machine. The name of the folder implies it was run on the 3rd July 2020 (200703), the machine ID is M01569, the run ID is 0148_000000000-J53HN, and this was called Batch70 locally within the [Medical Research Council-University of Glasgow Centre for Virus Research](https://www.gla.ac.uk/research/az/cvr/) (CVR) as part of a Covid-19 Genomics UK Consortium ([COG-UK](https://www.cogconsortium.uk)) sequencing run. The samples were sequenced using Version 1 (V1) of the ARTIC [nCoV-2019](https://github.com/artic-network/primer-schemes/tree/master/nCoV-2019) amplicon primers.

There are four samples in this run called:

* CVR2058
* CVR2078
* CVR2092
* CVR2101

If you list the contents of the directory you should see paired end reads (R1.fastq and R2.fastq) for each of the four samples.


These samples have already been trimmed/filtered using [trim_galore](https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/), so we do not need to QC them. For information, this is command that was used for each sample:

```
#DO NOT ENTER THE BELOW COMMAND- IT IS JUST FOR INFORMATION 
trim_galore -q 20 --length 50 --paired SAMPLE_R1.fastq SAMPLE_R2.fastq
```
### 1.3.2: Illumina consensus generation walkthrough

We will be using the [Wuhan-Hu-1](https://www.ncbi.nlm.nih.gov/nuccore/MN908947) SARS-CoV-2 isolate as the reference sequence, which has the GenBank accession number [MN908947](https://www.ncbi.nlm.nih.gov/nuccore/MN908947); this is also the sequence used as the basis for the SARS-CoV-2 RefSeq sequence [NC_045512](https://www.ncbi.nlm.nih.gov/nuccore/NC_045512). We will use [bwa](https://github.com/lh3/bwa) to align our reads to the reference.

First we need to index the reference sequence that we will be aligning our reads to. Indexing enables the aligner to quickly look up the best places to start aligning a read by using small sequences call 'seeds' from within the read and looking up if and where those seeds occur in the reference genome using the index.

```
mkdir Illumina_results
```

```
cd Illumina_results
```

```
cp /home/manager/SARS-CoV-2/MN908947.fasta .
```


```
bwa index MN908947.fasta 
```

This should of created a range of bwa index files (MN908947.fasta.amb/.ann/.bwt/.pac/.sa files), so list (```ls```) the contents of the directory to check:

```
ls 
```

You only need to index a genome once, if you are aligning many samples to the same genome sequence (as we will be on this course) you do not need to re-run the reference index step; but don't confuse this step with the BAM indexing step which does need to be done for each sample.

Now we will align the reads from sample CVR2058 to the reference sequence using bwa:


```
bwa mem -t4 MN908947.fasta /home/manager/SARS-CoV-2/Illumina/200703_M01569_0148_000000000-J53HN_Batch70/CVR2058_R1.fastq /home/manager/SARS-CoV-2/Illumina/200703_M01569_0148_000000000-J53HN_Batch70/CVR2058_R2.fastq > CVR2058.sam

```
Breaking this command down:

* **bwa** = the name of the program
* **mem** = the name of the bwa algorithm to use (it is recommended for reads > 70bp)
* **-t4** = use 4 computational threads
* **MN908947.fasta** = the path to the reference file (and index)
* **CVR2058_R1.fastq** = FASTQ read pair 1
* **CVR2058_R2.fastq** = FASTQ read pair 2
* **> CVR2058.sam** = direct the output into the file CVR2058.sam rather than to the command line

We now have a SAM file, which we immediately convert into a BAM file as they are compressed and faster to work with downstream. We can sort the file at the same time as converting it:


```
samtools sort -@4 CVR2058.sam -o CVR2058.bam
```
Breaking this command down:

* **samtools** = the name of the program
* **sort** = the name of the function within samtools to use
* **-@4** = use 4 threads
* **CVR2058.sam** = the input file
* **-o CVR2058.bam** =  the output file

We no longer need the SAM file so can delete (```rm```) it:

```
rm CVR2058.sam 

```
Now we need to index the BAM file, this makes downstream analyses faster and many downstream tools will only work if the index file has been created:

```
samtools index CVR2058.bam
```

If we list the contents of the directory we should see the index file with a .bai extension has been created:

```
ls
```


As we have used ARTIC amplicons, each read will typically start and end with a primer sequence. The primer sequence does not come from the sample's viral genome (and the primer may actually be slightly different to the virus) so all primer sequences should be removed from the read ends so they don't interfere with consensus and variant calling. 

To do this we use a tool called [ivar](https://andersen-lab.github.io/ivar/html/manualpage.html) which requires a [BED](https://software.broadinstitute.org/software/igv/BED) file containing the primer coordinates on the reference genome:

```
ivar trim -i CVR2058.bam -b /home/manager/artic-ncov2019/primer_schemes/nCoV-2019/V1/nCoV-2019.bed -p CVR2058_trim.bam
```
**NB:** Use **TAB Completion** to help enter the -b primer bed file!

Breaking this command down:

* **ivar** = the name of the program
* **trim** = the name of the function within ivar to use (trimming primers)
* **-i CVR2058.bam** = the name of the input BAM fie (it is in the current directory)
* **-b ~/artic-ncov2019/primer_schemes/nCoV-2019/V1/nCoV-2019.bed** = the path to primer BED file
* **-p CVR2058_trim.bam** = the name of the output file to create (which will be a primer trimmed version of the input BAM file)

For those who are interested ivar works by soft clipping the primer sequences from the read alignments in the BAM file (rather than actually trimming the reads sequences) based on the alignment coordinates. Soft clipping is a form of trimming that is embedded within the CIGAR string of a read alignment. The CIGAR string is the 6th field of the SAM/BAM file, if you were to examine the BAM file manually you should see lots of 'S' characters in the CIGAR field: see the [CIGAR specification](https://samtools.github.io/hts-specs/SAMv1.pdf) for more information.

We now need to sort and then index this BAM file. Sort:

```
samtools sort -@4 CVR2058_trim.bam -o CVR2058_trim_sort.bam 
```

Rename the file back to CVR2058\_trim.bam as we don't need the unsorted BAM file:

```
mv CVR2058_trim_sort.bam CVR2058_trim.bam
```

Index the BAM:

```
samtools index CVR2058_trim.bam
```

We now have a sorted and indexed BAM file (CVR2058\_trim.bam) that contains our sample's paired end reads (CVR2058\_R1.fastq CVR2058\_R2.fastq) aligned to the Wuhan-Hu-1 (MN908947) reference genome, with the amplicon primer sequences clipped off. So we are now ready to call a consensus sequence:

```
samtools mpileup -aa -A -d 0 -Q 0 CVR2058_trim.bam | ivar consensus -p CVR0258 -t 0.4
```

Breaking this command down, there are two parts:

1. samtools [mpileup](http://www.htslib.org/doc/samtools-mpileup.html) which essentially outputs the base and indel counts for each genome position
	* **-aa** = output data for absolutely all positions (even zero coverage ones)
	* **-A** = count orphan reads (reads whose pair did not map)
	* **-d 0** = override the maximum depth (default is 8000 which is typically too low for viruses)
	* **-Q 0** = minimum base quality, 0 essentially means all the data
2. ivar [consensus](https://andersen-lab.github.io/ivar/html/manualpage.html) - this calls the consensus - the output of the samtools mpileup command is piped '|' directly into ivar
	* -p CVR2058 = prefix with which to name the output file
	* -t 0.4 = the minimum frequency threshold that a base must match to be used in calling the consensus base at a position. In this case, an ambiguity code will be used if more than one base is > 40% (0.4). See [ivar manual]

By default, ivar consensus uses a minimum depth (-m) of 10 and a minimum base quality (-q) of 20 to call the consensus; these defaults can be changed by using the appropriate arguments. If a genome position has a depth less than the minimum, an 'N' base will be used in the consensus sequence by default.

ivar will output some basic statistics to the screen such as:

```
#DO NOT ENTER THIS - IT IS THE IVAR OUTPUT YOU SHOULD SEE
Reference length: 29903
Positions with 0 depth: 121
Positions with depth below 10: 121
```
and you should see our consensus sequence (CVR0258.fa) in the directory:

```
ls
```

which you can view via the command line (again, we will be doing variants in later sessions):

```
more CVR0258.fa 
```

### 1.3.3: Exercise: Generating Illumina consensus sequences yourself

There are three other samples in the Illumina data directory:

* CVR2078
* CVR2092
* CVR2101

You should now choose atleast one sample to create a consensus sequence for yourself by running through the above steps, but adapting them for the next sample (you simply need to change the input read names, and the output file names from CVR2058 to your next sample name). A reminder that the commands used were:

```
bwa mem -t4 ~/SARS-CoV-2/MN908947.fasta CVR2058_R1.fastq CVR2058_R2.fastq > CVR2058.sam
```

```
samtools sort -@4 CVR2058.sam -o CVR2058.bam
```

```
rm CVR2058.sam 
```

```
samtools index CVR2058.bam
```

```
ivar trim -i CVR2058.bam -b ~/artic-ncov2019/primer_schemes/nCoV-2019/V1/nCoV-2019.bed -p CVR2058_trim.bam
```

```
samtools sort -@4 CVR2058_trim.bam -o CVR2058_trim_sort.bam 
```

```
mv CVR2058_trim_sort.bam CVR2058_trim.bam
```

```
samtools index CVR2058_trim.bam
```

```
samtools mpileup -aa -A -d 0 -Q 0 CVR2058_trim.bam | ivar consensus -p CVR0258 -t 0.4
```

**QUESTION** - what is number of mapped reads in each of the samples you have looked at? Hint:

```
samtools view -c -F2308 input.bam
```

Overall, you should again see that we are simply running the same set of commands over and over again for different samples but just changing the input and output names. This is where the power of simple bash scripting and bioinformatics pipelines come into play, as relatively simple scripts can be written to automate this process.



## 3.3: SARS-CoV-2 Alignments

Just some quick notes on alignment (not part of this session). Aligning millions of SARS-CoV-2 sequences together can present problems computationally (not least the amount of time takes). Another issue is the large N tracts in sequences which have failed ARTIC amplicons, these can cause numerous issues during alignments resulting in spurious indels and an overall poor alignment. 

Different groups have taken different approaches to solve this. COG-UK uses the [grapevine](https://github.com/COG-UK/grapevine) pipeline which utilises minimap2 to align each read individually against the SARS-CoV-2 reference sequence (similar to aligning each read in a FASTQ read to the reference), insertions are then trimmed and the data is outputted from the BAM file to create a FASTA alignment whose length is the size of original reference sequence; an obvious downside here is that you loose all the insertions from the alignment. This is often combined with aggressive filtering of sequences that are too short and have too many N bases. An alternate tool is NextAlign which is part of [NextClade](https://github.com/nextstrain/nextclade), see the paper here: [https://joss.theoj.org/papers/10.21105/joss.03773]](https://joss.theoj.org/papers/10.21105/joss.03773).

Another approach when using [mafft](https://mafft.cbrc.jp/alignment/software/) is it's inbuilt (but experimental) option to [align all the sequences to a reference sequence]((https://mafft.cbrc.jp/alignment/software/closelyrelatedviralgenomes.html)) to build a full MSA, using options such as ```--6merpair --addfragments```, ```--keeplength``` to preserve the original alignment length (no insertions) and ```--maxambiguous X``` to remove sequences with too many ambiguous characters.


## 4: SARS-CoV-2 Group Practical

In this session, we will be working on some more Illumina paired end read data. The FASTQ data was downloaded from the [European Nucleotide Archive](https://www.ebi.ac.uk/ena/browser) (ENA), and there are 4 samples in total in ```/home/manager/SARS-CoV-2/Group/``` (the samples are not related to one another), with R1 and R2 FASTQ files for each:

* ERR9105817 - ARTIC primer version 4.1
* ERR9731990 - ARTIC primer version 4.1
* ERR9761275 - ARTIC primer version 4.1
* ERR9788433 - ARTIC primer version 4.1

The primer scheme to use is:

```
/home/manager/artic-ncov2019/primer_schemes/nCoV-2019/V4.1/SARS-CoV-2.scheme.bed
```

Your task is to work as a group in the breakout rooms to analyse these samples. Initial read QC (with trim_galore) is not required (but you could add it if you wanted).  You should:

* align the reads to the Wuhan-Hu-1 reference sequence
* Report the number of mapped reads
* Trim the ARTIC primers
* Call a consensus sequence


This is a flexible session, and a chance to collate all the steps that you have learnt onto a single sample(s).

As a group you could:

* Analyse a sample each and collate the results. As there are only 4 samples (and groups will likely be larger than 4) - multiple people could analyse a single sample and check you get the same results
* Write a bash script to process the sample automatically. Remember all the steps to analyse a sample are the same, it is just the input/output names that are changing. 





