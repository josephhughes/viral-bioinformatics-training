# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines
* Practical adapted from [Richard Orton's tutorial](https://github.com/WCSCourses/ViralBioinfAsia2022/blob/main/Modules/SARS-CoV-2.md) 

## Contents

* [3: Varant Calling tutorial](#3-variant-calling-tutorial)
	+ [2.1: Extracting statistics with weeSAM](#21-extracting-statistics-with-weesam)
	+ [2.2: Visualizing the alignment with Tablet](#2.2-visualizing-alignment-with-tablet)

## 3: Variant Calling tutorial

What we have done so far was concerned with creating an overall consensus sequence, which will contain consensus level variants. Often, we are also interested in sub-consensus “low frequency” variants to investigate the viral swarm. We will use a tool called lofreq to call both high and low frequency variants in the BAM file with respective to out reference sequence:

```
cd GECO_course_data/Reference_alignment
```
```
lofreq call -f MN908947.fasta -o var.vcf Vero_SARS2.bam
```

This tells lofreq to call variants using the reference (**-f**) sequence ```MN908947.fasta```, to output the variants into the file ```var.vcf```, and to operate on the ```Vero_SARS2.bam``` file.
If we open up the ```var.vcf``` file, we will see numerous variants:
```
more var.vcf
```

The VCF file contains the following fields:

1. Chrom – the name of the reference sequence the variant is located on
2. Pos – the position of the variant on the reference sequence
3. ID – this is typically a dot – you can link known variants to a DB to give them names
4. Ref – the reference base
5. Alt – the alternate/variant/mutated base      
6. Qual – quality
7. Filter – whether it passed the filter statistical tests 8) Info – this field contains a wealth of data:

* DP = depth
* AF = The variant allele frequency
* SB = The result of the strand bias test
* DP4 = The raw counts of the reference and allele base in forward and reverse
directions: RefFwd, RefRev, VarFwd, VarRef

If you examine the file you should be able to see that the variants range from low frequencies (such as 1% [0.01] and 2% [0.02]) to consensus level (100% [1.0] e.g., position 14805).

**Questions** What has happened at site 5340 and site 26141? What frequency are these mutations at?

One thing missing now is characterising the mutations – determining if they are non-synonymous, synonymous or in non-coding regions. To do this we will use a tool called ```DiversiTools/DiversiUtils```, this needs details of the ORFs in the reference genome which we have already created in ```Coding.regions.SARS2.txt```. It is a simple text file that gives the start and stop co-ordinates of each gene.

```
diversiutils_linux -bam Vero_SARS2.bam -ref MN908947.fasta -orfs Coding.regions.SARS2.txt -stub diversi
```

The diversi_AA.txt output file contains a lot of information for each amino acid site. The amino acid counts have been calculated from the read level data.

**Questions** Find the corresponding amino acids for sites 5340, 14805 and 26141 keeping in mind that these sites may be the 1st, 2nd or third base of a codon? Are the changes sysnonymous or non-synonymous?  

