# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines

## Contents

* [3.2: *De Novo* Assembly Tutorial](#32-de-novo-assembly-tutorial)
	+ [3.2.1: Introduction](#321-introduction)
	+ [3.2.2: Retrieving the sequencing reads](#322-retrieving-the-sequencing-reads)
	+ [3.2.3: Processing the reads](#323-processing-the-reads)
		+ [sequencing read files](#sequencing-read-files)
		+ [read quality](#read-quality)
		+ [trimming](#trimming)
	+ [3.2.4: *De Novo* Assembly](#324-de-novo-assembly)
		+ [SPAdes](#spades)
		+ [ABySS](#abyss)
	+ [3.2.5: Extended Material](#325-extended-material)



# 3.2: *De Novo* Assembly Tutorial 


## 3.2.1: Introduction

In this practical we will explore how to make a *de novo* assembly from sequencing reads (illumina paired-end reads will be used).

Since we won't be sequencing our own samples in this course, we will use existing, publicly available reads.
(but you can use the same commands for *de novo* assembling any sequencing read dataset!)

The reads we will use today have been deposited in the [Sequence Read Archive (SRA)](https://www.ncbi.nlm.nih.gov/sra), 
a database of raw sequencing data corresponding to the majority of published research. 

The SRA is structured into bioprojects (for example an entire study) that each contain a number of experiments
(these could be individual samples or different experimental conditions). Finally each experiment might have multiple
sequencing runs if, for example, the submitters decided to sequence the same sample multiple
times or using different methods. 

The practical will focus on examining metagenomic samples from an exotic animal that has recently
gathered a lot of attention, the pangolin! 

The bioproject in question has been submitted by the Guangdong Institute of Applied Biological Resources and 
has the accession [PRJNA573298](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA573298).

If you visit the SRA page for this bioproject can you spot:

- how many experiments are there in this project?

- how many base pairs have been sequenced in total?

For the purpose of the course we will focus on the 2 (most interesting) experiments of this project:
[SRX6893153](https://www.ncbi.nlm.nih.gov/sra/SRX6893153) and [SRX6893154](https://www.ncbi.nlm.nih.gov/sra/SRX6893154).

- What can you say about the experiments (sequencing technology, type of sample, etc.)? 

- How many sequencing runs does each experiment have and what are their accessions (should start with 'SRR')?


## 3.2.2: Retrieving the sequencing reads

❗ Before we get started, it is crucial to keep the directories where you'll be running the analysis as
tidy as possible. 

Start off by making a new directory for this practical, e.g.

`mkdir denovo_assembly`

and move into it:

`cd denovo_assembly`

<br>

Theoretically you could download the sequence reads through a browser using the SRA web pages provided above,
however there are many caveats with this approach:

1. Raw sequencing reads are usually very large files, difficult to store in a local machine (better off on a server).
2. For the same reason, a stable internet connection is required for retrieval and - depending on your internet speed - 
multiple hours may be required for downloading.
3. Most bioinformatic analyses take place on the terminal. This is because you can create pipelines
to automate the retrieval of multiple files at once instead of spending hours clicking on a browser.

For all these reasons, it's better to retrieve SRA datasets using the command line and store them directly
on the server (or stable machine) where all downstream analyses will be run. 

The [sra toolkit](https://github.com/ncbi/sra-tools) is a package of command line tools for exploring and retrieving SRA sequencing data
without the need to use a browser (or any graphical interface whatsoever). 

Using the `fastq-dump` module of the sra toolkit, one can download sequencing reads through the command line
by simply providing the run accessions of the reads they would like to work on. 


Hopefully you have found which run accessions correspond to the SRA experiments we are going to explore (SRX6893153, SRX6893154).

Then to retrieve these you can run the following command:

```
fastq-dump --skip-technical --read-filter pass --split-3 SRR10168377 SRR10168378 
```

Let's break this down: 

- `fastq-dump` is the module for retrieving sequencing reads

- `--skip-technical` downloads only biological reads (no technical reads)

- `--read-filter pass` removes reads full of Ns or of low quality

- `--split-3` splits the reads into forward and reverse read files for paired end reads (are our reads paired-end?)
	
the 3rd file would include any singleton reads (if there are any)

❗ If you don't know how a module works, always use the `--help` option, 
e.g.

`fastq-dump --help`

this will show you how to use the commands as well as all available options and their function.


On a fast internet connection it takes approximately 30 minutes to download the files of each run.
To save time, we have downloaded these for you and subsampled\* them to aid downstream analysis.

You can copy these from the `/home/manager/GECO_course_data/Denovo_assembly` directory into your newly made `denovo_assembly` directory.

📝 See how we used other sra toolkit modules for the subsampling step in [Extended material](#extended-material).

## 3.2.3: Processing the reads

Before we start assembling to our heart's content, let's have a good look at the data. 

### sequencing read files

In your directory you should have two files for each SRR accession (how do you check that?)

- Can you print the first few lines of each file?

- What type of files are these?

- What do the lines represent (remember the file types tutorial)?

- How many reads are there in each file?

	📝 Make sure you copy all the commands you run to answer these questions on a separate text file, 
	so you can reuse them in the future!


### read quality

Before doing any assembling we might want to examine the quality of the raw reads first.

The [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) program quantifies read quality and creates an html report to visualise the results. 

Run this by specifying the file names of both paired-end read files for each run:

```

fastqc SRR10168377_pass_1_sub.fastq SRR10168377_pass_2_sub.fastq

```

- What is the output of the `fastqc` command?

To keep things tidy you might want to keep quality reports in a separate subdirectory.

- Can you create this and then move the reports in it?


### trimming

One very important sequencing read processing step is called trimming. That's where 
we remove the adapters (or partial adapter sequences) from the reads. 

Software like [Trim Galore](https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/) make this task very easy, since it automatically detects 
the type of adapters present in the reads and clears them for you.

You only need to tell the software whether the reads are paired-end and provide the file names, e.g.:

```

trim_galore --paired SRR10168377_pass_1_sub.fastq SRR10168377_pass_2_sub.fastq

```

- What is the output of the `trim_galore` command?

- Is there any output file you might want to move to the *reports* subdirectory?


## 3.2.4: *De novo* assembly

Now that we have retrieved, explored and trimmed our sequencing reads it is time to assemble!

Since this is a *de novo* assembly tutorial, we won't be needing a reference sequence. Instead
we will use assembling algorithms to put together contigs only based on the reads we have.

We will try two different algorithms both of which use the de Bruijn graphs method (best for short Illumina reads). 
The first one, [SPAdes](https://github.com/ablab/spades), is a pipeline that chooses the k-mer size itself based 
on the sequencing reads provided and tries a few different sizes to make the final assembly
(remember how we discussed this at the start of the session). On the other hand, we have to specify the k-mer size to be used
by the second program, called [ABySS](https://github.com/bcgsc/abyss).

### SPAdes

First we will run SPAdes as follows:

```

spades.py -t 1 --rnaviral -1 SRR10168377_pass_1_sub_val_1.fq -2 SRR10168377_pass_2_sub_val_2.fq -o spades_SRR10168377/

```

Let's break this down: 	

- `spades.py` is the spades module (notice the .py extension means that it's a python script running the pipeline)

- `-t` is the number of threads to be used (be considerate of this when working on shared server space)

- `--rnaviral` is a tag for better assembling viral RNA reads (just like the ones we have!)

- `-1` and `-2` indicate the two paired-end read files

- `-o` defines the output directory's name

<br>

- What k-mer sizes did spades decide to use?

- How many contigs were produced for each sample?

- Are there any differences between the `contigs.fasta` and the `scaffolds.fasta` files?

- What is the largest and what is the shortest contig assembled?



### ABySS

Unlike SPAdes, when using ABySS we need to specify the k-mer lengths to be used.
Given that we have already run SPAdes, what k-mer lengths could you choose for ABySS?

Also, ABySS will not create the output directory for you, so we'll first need to 
create each output directory and make soft links of the read files with the `ln -s` command.

```

mkdir SRR10168377_abyss_k49

cd SRR10168377_abyss_k49

ln -s ../SRR10168377_pass_1_sub_val_1.fq .
ln -s ../SRR10168377_pass_2_sub_val_2.fq .

```

Now we can run ABySS in that directory:

```

abyss-pe name=SRR10168377_k49 k=49 B=1G in='SRR10168377_pass_1_sub_val_1.fq SRR10168377_pass_2_sub_val_2.fq' -j 1
```

Let's break this down: 

- `abyss-pe` is the abyss assembling module

- `name=` defines the name of the assembly

- `k=` defines the k-mer size

- `B=` Bloom filter defines amount of memory to be used

- `-in=` indicates the input files (shoud be put into quotes if two paired-end read files are specified)

- `-j` number of jobs to split up the work into (same as threads in spades)

Try at least two different k-mer sizes with ABySS.

- Can you see any differences in contig reconstruction between the different k-mer size runs?

- Could you try a much lower or much higher k-mer size? How would this affect the assembly?


<br>

## 3.2.5: Extended Material

In the *de novo* assembly practical the sequencing read datasets have been 
subsampled to reduce computing time. This was not done randomly, rather the retained
reads were checked to match a virus of interest. 

The SRA toolkit - previously mentioned in the practical - has a number of modules
(like `fastq-dump` that we used in the main practical), including `blastn_vdb` which
allows you to screen a given set of sequences using BLAST against all individual reads
of an SRA experiment even before doing any assembling (or even downloading the assembly). 

Hence, to selectively subsample the raw reads we used the `blastn_vdb` with each SRA
experiment accession as the screening database (`-db`) and a fasta file only including the
virus of interest's genome sequence as the query (`-query`):


```
blastn_vdb -db "SRR10168377" -query sub.fasta -out SRR10168377_sub_blast.txt
```

After that we used the following simple unix commands to parse the blast output
and create the subsampled read files:

```
cat SRR10168377_sub_blast.txt | grep 'SRA:' | grep '\.1 ' | cut -d ' ' -f 2 | sed "s/$/ length/" > SRR10168377_sub_blast_acc1.txt
cat SRR10168377_sub_blast.txt | grep 'SRA:' | grep '\.2 ' | cut -d ' ' -f 2 | sed "s/$/ length/" > SRR10168377_sub_blast_acc2.txt
cat SRR10168377_pass_1.fastq | grep -A 1 --no-group-separator -f SRR10168377_sub_blast_acc1.txt > SRR10168377_pass_1_sub.fastq
cat SRR10168377_pass_2.fastq | grep -A 1 --no-group-separator -f SRR10168377_sub_blast_acc2.txt > SRR10168377_pass_2_sub.fastq

```

- Can you tell what these commands are doing?


```

mkdir spades_combined

cat SRR10168377_pass_1_sub_val_1.fq SRR10168378_pass_1_sub_val_1.fq > spades_combined/SRR10168377n8_pass_1_sub_val_1.fq

cat SRR10168377_pass_2_sub_val_2.fq SRR10168378_pass_2_sub_val_2.fq > spades_combined/SRR10168377n8_pass_2_sub_val_2.fq

cd spades_combined

spades.py -t 1 --rnaviral -1 SRR10168377n8_pass_1_sub_val_1.fq -2 SRR10168377n8_pass_2_sub_val_2.fq -o combined

cat spades_SRR10168377/contigs.fasta | grep '>' | cut -d '_' -f 4 | sort -nr | head -5


```






