# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines

## Contents

* [3.3: Metagenomics Tutorial](#33-metagenomics-tutorial)
	+ [3.3.1: Introduction](#321-introduction)
	+ [3.3.2: Kraken: reads metagenomics](#332-kraken2-reads-metagenomics)
		+ [Visualise results with Krona](#visualise-results-with-krona)
	+ [3.3.3: DIAMOND: contig metagenomics](#333-diamond-contig-metagenomics)
	+ [3.3.4: *De Novo* Assembly and Metagenomics Combined Practical](#334-de-novo-assembly-and-metagenomics-combined-practical)
		+ [Final task](#final-task)


# 3.3: Metagenomics Tutorial

## 3.3.1: Introduction

Following on from the [*De Novo* Assembly Tutorial](https://github.com/josephhughes/viral-bioinformatics-training/blob/main/Denovo_assembly/denovo_practical.md) we will use the same set of pangolin 
sequencing reads that we previously processed for this metagenomic practical.


## 3.3.2: Kraken: reads metagenomics

We will start with one of the most popular tools for classifying metagenomic reads: [Kraken2](https://ccb.jhu.edu/software/kraken2/).

❗ Since you already learned about Kraken earlier today at the [Pathogen Detection Tutorial](https://github.com/josephhughes/viral-bioinformatics-training/blob/main/ReadProfiling/GECO_PathogenDetection.md),
we're going to do this section quickly, applying what you learned on the current dataset.

Kraken uses a k-mer based approach (similar to what we discussed in the de novo assembly lecture)
and tries to match fragments of your read dataset to a sequence database.
Kraken's advantages are: i) it's very fast compared to other programs and ii) it's taxonomy-aware
meaning that the sequence database has a structure of how sequences are related, so Kraken won't just tell
you if your reads match to a single sequence, but will match each k-mer within a query sequence to the 
lowest common ancestor (LCA) of all genomes containing the given k-mer.

📝 Remember to make a new directory for running the Kraken analysis to keep things tidy!


To run Kraken you will also need a local kraken database. We have already compiled this for you at `/home/manager/db/kraken2/virus`.
You can read more about how to make custom databases at the [kraken github page](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown#custom-databases).

Now it's time to find out what kinds of reads are in the read samples you already trimmed and prepared for the [*De Novo* Assembly Tutorial](https://github.com/josephhughes/viral-bioinformatics-training/blob/main/Denovo_assembly/denovo_practical.md).


```

kraken2 --db /home/manager/db/kraken2/virus --quick --output SRR10168377_kraken.out --report SRR10168377_report.txt --paired SRR10168377_sub_pass_1_val_1.fq SRR10168377_sub_pass_2_val_2.fq

```

Let's break this down: 

- `kraken2` is the classifier module of Kraken2

- `--db` specifies the directory of the precompiled database

- `--quick` is a tag for making the process quicker (what would change if we run without?)

- `--output` specifies the kraken output file (full output)

- `--report` specifies the file where a summary report of the results can be written

- `--paired` since we have paired-end reads in separate files we need to use this tag


What percentage of reads were classified successfully for each sample?

What kind of format does the kraken output and report files have?

A detailed explanation of the output formats can be found [here](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown#output-formats)


Now that you understand how the output files are structured can you tell what viruses (and what other biological entities)
are found in the samples just by looking through the `report.txt` file?

Try and use bash commands that you learned at the start of the course like `grep`, `cat` and `less`. 
What would the following command show you?

`cat SRR10168377_report.txt | grep -A 150 'Virus' | less`

<br>


### Visualise results with Krona

Parsing the Kraken `report.txt` file is the most efficient way of viewing the classification results, but 
probably not the most eye-friendly way. There is another tool for quickly creating interactive charts to
visually explore the results called [KronaTools](https://hpc.nih.gov/apps/kronatools.html).

KronaTools is a set of scripts that can read datasets like the ones Kraken produces and create interactive 
pie charts called [Krona plots](https://github.com/marbl/Krona/wiki) in html format (they can be viewed in 
a browser).

First we need to sligthly reformat the kraken output with the following bash command:

```

cut -f2,3 SRR10168377_kraken.out > SRR10168377_kraken.kronainput

```

- Can you tell what this command does to the kraken output?

Now let's make the Krona plots! 

```

ktImportTaxonomy -tax /db/kronatools/taxonomy SRR10168377_kraken.kronainput -o SRR10168377_krona.html

```

You can view the html using `firefox` or any other browser.

Look through the results, what can you see?

- What type of viruses are in the dataset?

- Remember that we used a local database to classify our read. Can you identify any caveats with this approach in the results?

<br>

## 3.3.3: DIAMOND: contig metagenomics

The Kraken2 approach above is a very fast way to classify raw sequencing reads, but even though
it gives you a general idea of what organisms are in a sample, it doesn't tell you what
specific sequences have been sequenced, which would allow downstream analysis of the findings.

Instead, we can do metagenomics on the contigs or scaffolds we have already assembled, by using a
local alignment approach. The most popular method is a tool you might have encountered before called
[BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi). This method makes pairwise alignments between a set of
query sequences (in this case your assembled contigs) and a database of sequences (for example 
the [NCBI Genbank](https://www.ncbi.nlm.nih.gov/genbank/) database). In contrast to the k-mer approach we
tried before, here entire sequences are being compared to the database sequence and not just fragments 
of them. 

You could use command line BLAST against a local database (`my_db`), e.g.:

```
blastn -db /db/my_db -query contigs.fasta -out blast.out
```

or you could even run BLAST remotely through the command line, just like you would do
on a browser (given a stable internet connection):

```
blastn -db nt -query contigs.fasta -out blast.out -remote
```

There are many useful options provided by the BLAST command line tool you can explore
by running the `--help` option:

`blastn --help`

`blastp --help`

`tblastx --help`

`blastx --help`

`tblastn --help`

- What does each of the 5 programs above do?

The main downside of doing metagenomics with BLAST is that it's much slower and computationally
intensive compared to other approaches, especially with large metagenomic datasets.

To avoid this problem, another software similar in concept to `tblastx` `blastx` (remember what these versions
of BLAST do?) has been developed called [DIAMOND](https://github.com/bbuchfink/diamond).

DIAMOND can run 500 or even more times faster than normal BLAST and can give results of similar accuracy. 
That's why it's considered a very good tool for metagenomic datasets. You can read more about the details in the
[DIAMOND paper](https://www.nature.com/articles/s41592-021-01101-x).

Now let's try using DIAMOND on our assembled contigs (the ones we made earlier today using SPAdes and AbYSS).
Again the database you'll be using has been precompiled for you and contains all refseq virus proteins.

- Can you find how you would make your own DIAMOND database in the `diamond help` menu?


📝 Remember to make a new directory for running the DIAMOND analysis to keep things tidy!


```
diamond blastx -d /db/virusrefseq -p 2 -q ../denovo_assembly/spades_SRR10168377/contigs.fasta -o spades_SRR10168377 -t spades_SRR10168377_temp/ --top 3 --outfmt 6
```

Let's break this down: 

- `diamond` is calling the DIAMOND program

- `blastx` is telling DIAMOND to use its blastx option (what does this compare? what other options are there?)

- `-d` species the database to be used

- `-p` is the number of threads to be utilised

- `-q` specifies your query sequences

- `-o` specifies the results output file

- `-t` a temporary directory for the analysis

- `--top` the number of top hits to be included in the results

- `--outfmt` the output format (can you tell what different output formats look like?)


Once DIAMOND has finished running take a look at the results, do they match the Kraken2 results?

You can also make Krona plots out of DIAMOND results in a similar way to how you did it with the Kraken2 results:

```

ktImportBLAST spades_SRR10168377.txt -o spades_SRR10168377_DIAMOND.html

```


- Based on all the results, what kind of viruses are in the metagenomic dataset?

- What host reads are in the dataset?

- Are there any interesting findings?

- Based on your current assessment, what downstream analysis would you do?

<br>


# 3.3.4: *De novo* Assembly and Metagenomics Combined Practical

Now that you have become familiar with both *de novo* assembly and metagenomics approaches 
and have sufficiently explored the sequencing dataset that was given to you, it's time to reveal
where these read came from.


Both samples came from the lungs of two dead Malayan pangolins that had been illegally trafficked
and rescued by the border customs of China's Guangdong province.

The original sequencing runs which you analysed here were published by [Liu *et al.* (2019). *Viruses*](https://www.mdpi.com/1999-4915/11/11/979), before 
the COVID-19 pandemic, and were of quite low quality (what was your longest contig with different approaches?).

Among other viruses identified by the metagenomic analysis there were few traces of SARS-related coronavirus sequences
in the lung samples of two of the animals (sample runs SRR10168377 and SRR10168378).

The subsampled read datasets that you assembled in the [*De Novo* Assembly Practical](https://github.com/josephhughes/viral-bioinformatics-training/blob/main/Denovo_assembly/denovo_practical.md) only contained reads 
matching to the coronavirus genome, that's why all your contigs should be from that genome.

- How long is an average coronavirus genome and how does that compare to your contigs' length?

After the SARS-CoV-2 virus was identified in humans many metagenomic samples were screened again
to identify related viruses previously sampled in animals. This is a prime example of 
wild animal metagenomic studies helping us understand the origins and diversity of human emerging viruses. 
However, there's more to the story of these samples:

When the metagenomic datasets were confirmed to contain virus reads closely related to SARS-CoV-2, 
the samples were sent to two independent labs for performing targeted sequencing for SARS-CoV-2-like sequenices
with PCR-amplification.

Both labs were able to sequence all remaining parts of the pangolin coronavirus and assemble the complete genome 
that were subsequently published in the two papers below (where you can read the full sequencing methods): 

- [Liu *et al.* (2020). *Plos Pathogens*](https://doi.org/10.1371/journal.ppat.1008421)

- [Xiao *et al.* (2020). *Nature*](https://www.nature.com/articles/s41586-020-2313-x)

The only problem was that both labs were unaware of the other lab working on sequencing the virus samples.
This meant that neither paper acknowledged the other team's results and both papers essentially
reported the same pangolin coronavirus genome. 

Once the journal editors were notified of this and investigated the issues, corrections were published for both
papers acknowledging the issue:

[Correction to Liu *et al.* (2020). *Plos Pathogens*](https://doi.org/10.1371/journal.ppat.1009664)

[Correction Xiao *et al.* (2020). *Nature*](https://www.nature.com/articles/s41586-021-03838-z)

This is an interesting example of how sequencing data sharing problems can occur, 
especially when the data is crucial for understanding emerging pathogens. What do you think
about this?


<br>

We have already assessed that the quality of the coronavirus reads was fairly low in the 
original set we analysed just based on the assembled contig length. Now that we have a fully assembled 
'reference' genome subsequently published in the papers above, we can properly assess the contig 
quality of our assembly and compare this between assembling methods, using a tool called 
[metaQuast](https://academic.oup.com/bioinformatics/article/32/7/1088/1743987).

The reference pangolin CoV genome we're going to use is called MP789 and a fasta file
of the whole genome sequence can be found in the `/home/manager/GECO_course_data/Metagenomics` directory. 

metaQuast can be used as follows:

```
metaquast.py -o quast_results/ -r MP789.fasta -m 100 -t 2 SRR10168377_abyss/SRR10168377_k49-1.fa SRR10168377_spades/contigs.fasta
```
Let's break this down: 

- `metaquast.py` is calling the metaQuast program (notice that it's a python script)

- `-o` specifies the output folder
	
- `-r` species the reference genome in fasta format

- `-m` specifies the amount of memory to be utilised

- `-t` specifies the number of threads to be utilised

- after these arguments you can specify a number of contig fasta files you assembled to compare


metaQuast creates an html file (similar to KronaTools) that you can view using a browser.
Check the quality of each assembly method and each sample.

- What part of the genome has been assembled?

- Which method has the best assembly quality?


<br>

## Final task

If we get extra time you can practice on a whole new dataset! 

Try running everything we did today for the `SRR11093265` sequencing dataset.

You can find the raw dataset in the `/home/manager/GECO_course_data/Metagenomics` directory or try downloading it yourself.

- Do you notice anything different with this sample?