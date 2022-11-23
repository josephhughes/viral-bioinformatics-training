# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines

## Contents

* [4: Pathogen detection tutorial](#3-pathogen-detection)
	+ [4.1: Kaiju](#41-kaiju)
	+ [4.2: Kraken](#42-kraken)

## 4: Pathogen detection

For this practical, we will use a non-SARS2-related sample that is in the public repository but you will get the opportunity to investigate some SARS2-related metagenomic samples during the group practical. 

The data for this practical comes from a metagenomic study of 195 patients with unexplained acute febrile illness which was compared to 328 apparently healthy control individuals from communities in southeastern Nigeria:

Stremlau MH, Andersen KG, Folarin OA, Grove JN, Odia I, Ehiane PE, Omoniwa O, Omoregie O, Jiang PP, Yozwiak NL, Matranga CB, Yang X, Gire SK, Winnicki S, Tariyal R, Schaffner SF, Okokhere PO, Okogbenin S, Akpede GO, Asogun DA, Agbonlahor DE, Walker PJ, Tesh RB, Levin JZ, Garry RF, Sabeti PC, Happi CT. Discovery of novel rhabdoviruses in the blood of healthy individuals from West Africa. PLoS Negl Trop Dis. 2015 Mar 17;9(3):e0003631. doi: 10.1371/journal.pntd.0003631. eCollection 2015 Mar. PubMed PMID: 25781465

Blood was collected from each individual and the RNA was extracted. RNA-seq libraries were constructed sometimes for single individuals or from pooled RNA from several individuals. The samples were sequence on an Illumina HiSeq 2500 producing 100bp paired-end reads.

In this practical, we will use a set of reads (SRR1748193) from a sample collected from an apparently healthy female individual (body temperature 37.2, signs of inflammation, facial and neck endema, with headaches, a cough and weakness).

The sample has already been downloaded using the commands in the box below and processed using de-novo assembly approaches (abyss and spades). The contigs from these approaches have been consolidation into a single set of non-overlapping contigs. 

> **Note**
> SRA Toolkit 
>  
A set of bioinformatic command line tools for querying and downloading sequences from the Sequence Read Archive.

> Availability: [https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software)

> Documentation:  [https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc)

> Example command that I usually use:
> ```fastq-dump --outdir fastq --gzip --skip-technical --read-filter pass --split-3 SRR1748193```

> The output directory is specified with --outdir and the output is compressed (--gzip). --skip-technical dumps only the biological reads, --read-filter pass filters out all the reads that are useless such as all N’s, --split-3 will give you three files, a left file, a right file and a singletons file. Change SRR1748193 for the identifier of the file you want to download.


In this practical, we will use two different fast classifying approaches directly on the reads. 

### 4.1: Kaiju

Kaiju is a program for the taxonomic classification of high-throughput sequencing reads from metagenomic samples. Reads are directly assigned to taxa using the NCBI taxonomy and a reference database of protein sequences from microbial and viral genomes.

The program is described in Menzel, P. et al. (2016) [Fast and sensitive taxonomic classification for metagenomics with Kaiju.](http://www.nature.com/ncomms/2016/160413/ncomms11257/full/ncomms11257.html) Nat. Commun. 7:11257 (open access).

The program can be obtained from [github](https://github.com/bioinformatics-centre/kaiju) and there is also a [webserver](https://kaiju.binf.ku.dk/server)

For this practical, a reference database for viruses has been created and is stored in ```/home/manager/db/kaijudb```. First, look at the folder with the fastq files  ```ls /home/manager/GECO_course_data/Pathogen_detection```.

Create a new dirctory
```
mkdir Readprofiling_tutorial
```

Go into the directory
```
cd Readprofiling_tutorial
```

Then run Kaiju which requires at least three arguments:

```
/home/manager/Programs/kaiju/bin/kaiju -t /home/manager/db/kaijudb/nodes.dmp -f /home/manager/db/kaijudb/kaiju_db_viruses.fmi -i /home/manager/GECO_course_data/Pathogen_detection/fastq/SRR1748193_pass_1.fastq.gz -j /home/manager/GECO_course_data/Pathogen_detection/fastq/SRR1748193_pass_2.fastq.gz -o SRR1748193_kaiju.out
```

* **-t** specifies the taxonomy hierarchy and is obtained from the NCBI taxonomy
* **-f** specifies the kaiju database, in this case of viruses
* **-i** and **-j** are for the paired reads files

Kaiju comes with a number of helper programs that can help to produce tables or figures to visualize the results. Here, we use kaiju2krona to convert Kaiju's tab-separated output file into a tab-separated text file, which can be imported into Krona. It requires the nodes.dmp and names.dmp files from the NCBI taxonomy for mapping the taxon identifiers from Kaiju's output to the corresponding taxon names.

```
/home/manager/Programs/kaiju/bin/kaiju2krona -t /home/manager/db/kaijudb/nodes.dmp -n ~/db/kaijudb/names.dmp -i SRR1748193_kaiju.out -o SRR1748193_kaiju.out.krona
```

The file ```SRR1748193_kaiju.out.krona``` can then be imported into Krona and converted into an HTML file using Krona's ktImportText program:

```
ktImportText -o SRR1748193_kaiju.out.html SRR1748193_kaiju.out.krona 
```

We can open up the html file using firefox and view the Krona plot:

```
firefox SRR1748193_kaiju.out.html
```

**Question:** What was the woman infected with?

**Question:** Why do we have hits to Capuchin monkey hepatitis B virus? Was she really infected by this virus?


### 4.2: Kraken

Kraken is a kmer based tool for metagenomics, it can give you an indication of what is in your sample by analysing your FASTQ reads and classifying them based on any viral specific kmers that they contain.

We are going to investigate the same SRR1748193 sample to find out if there are any viruses in it. First, we will run kraken against the Mini-Kraken database which is quick:

```
kraken2 --db /home/manager/db/kraken2/virus/ --quick --output SRR1748193_kraken.out \
--report SRR1748193_report.txt \
--paired /home/manager/GECO_course_data/Pathogen_detection/SRR1748193_pass_1_val_1.fq.gz /home/manager/GECO_course_data/Pathogen_detection/SRR1748193_pass_2_val_2.fq.gz
```
 
This will create a kraken output file called ```SRR1748193_kraken.out```, which contains the taxonomic assignment of each read pair.
The file ```SRR1748193_report.txt``` provide a report with the number of reads mapping at each taxonomic level but it is not very human readable, so we will use Krona again to visualise/inspect the kraken results.

#### 4.2.1 Visualisation

First we use a perl script to convert the kraken report into a format that is readable by krona:

```
/home/manager/Programs/kraken2-translate.pl SRR1748193_report.txt > SRR1748193_kraken.krona.txt
```

Now, we run the ```ktImportText``` command for creating the krona plot:

```
ktImportText -o SRR1748193_kraken.out.html SRR1748193_kraken.krona.txt 
```

Now we can view the result in a krona plot:

```
firefox kraken_output.html
```

This will open the Krona plot in the firefox web browser. Have a play with the Krona plot, try expanding viruses, and exploring through the taxonomy.

**Question** Has kraken detected the same viruses as Kaiju?
