# Tree Building and Phylogenetic Analysis

## Introduction

In this practical we will be using Omicron SARS-CoV-2 sequences. Due to time constraints, we will be using a subset of sequences (trees can take a very long time to run if there are a lot of sequences!). A representative set of sequences from multiple countries has been selected.

We will be analysing and interpreting best fitting substitution models, bootstrap values and finding the best ways to visualise trees. We will also be extracting useful metadata from sequence IDs and annotating this on to phylogenetic trees. 

You will be using the terminal for some of this, but navigating to the relevant directory with ```cd``` is the only command you'll need to remember - any other new commands will be detailed here. 

## Preparation

Start by making a folder for the analysis. Make sure this is somewhere easy to navigate to in the terminal! 

You'll then need to copy the fasta file `omicron_subset_countries.fasta` we'll use for this practical from the `~/Phylogenetics` folder. You can do this manually or practice your command line skills! 

## Alignment

To make trees, sequences first need to be aligned! We will do this using mafft.

Open up the terminal and navigate to the directory you just made using `cd`. 

Write the command `mafft omicron_subset_countries.fasta > omicron_subset_countries_aligned.fasta` 

This will create the file `omicron_subset_countries_aligned.fasta` in your folder - this contains the sequences from `omicron_subset_countries.fasta` aligned by the FFT-NS-2 algorithm.

It's generally a good idea to take a quick manual look at the alignment file before proceeding. You can open the fasta file in an alignment viewer for a full look, or open in a text editor for a quick look. For now, just open the file in a text editor.

**How many sequences does this fasta file contain?**
Hint: You can do `ctrl+f` to search the file, and search for the `>` character, of which each will denote a sequence. The number of `>`'s should display in the search bar. 

## Model selection

Finding the substitution model that best fits the data is very important. There are various tools to estimate the best substitution model but for now, we're going to use the inbuilt modeltest function in IQTREE.

### About the program - IQTREE

This  program  allows  you  to  perform  Maximum  Likelihood phylogenetic  analysis.  It  uses  efficient algorithms  to explore the tree  space,  allowing  very  large  matrices  to  be  analyzed  with  reliable  results (hundreds  /  thousands  of  sequences).  It  allows  estimating  the  evolutionary model (ModelFinder module) followed  by the  phylogenetic analysis and implements  support  measures  to evaluate  the reliability  of  the  groupings  (Bootstrap,  Ultrafast  Bootstrap  Approximation  and  probabilistic  contrasts). The program can be downloaded and run locally, or on online servers such as:
http://iqtree.cibiv.univie.ac.at/
https://www.phylo.org/
https://www.hiv.lanl.gov/content/sequence/IQTREE/iqtree.html
You can find many basic and advanced tutorials in http://www.iqtree.org/doc/


In the terminal, make sure you're still in the correct directory.

Type: `iqtree2 -h` to see all the command options for IQTREE, and note any that may be useful.

You may notice the `-m` argument to specify a model. You can run `-m TEST` when making a tree to find the best substitution model and then make a tree using that model. Alternatively, you can use `-m TESTONLY` to find the best fitting substitution model without making a tree.

Other important arguments we'll be using include:

`-s` to specify the name of the alignment file,always required by IQ-TREE to work.

`-B` to specify the number of replicates for ultrafast bootstrap in IQ-TREE v2. Slightly less accurate than regular bootstrapping, but MUCH faster.

`-b` to specify the number of replicates for regular bootstrapping. Either this or `-B` can be used, not both.


To start with, we'll run the modeltest without running a tree.

In the terminal, type `iqtree -s omicron_subset_countries_aligned.fasta -m TESTONLY` 


**What is the best fitting model?**
Hint: This will be on the terminal screen, you may have to scroll up a little to under where each model was tested.

**What do the parameters of the best fitting model mean?**

## Tree building

Now we know the best fitting model, we can make our tree!

In the terminal write `iqtree -s omicron_subset_countries_aligned.fasta -m BEST_FITTING_MODEL -B 1000 -redo` replacing `BEST_FITTING_MODEL` with the model you found in your last step.

This command means we are building this tree with 1000 ultrafast bootstrap replicates. The `-redo` argument is necessary to overwrite the files made in the last step and allow this to run.

You'll notice a lot of new files appear in your directory. The ones we're most interested in are the `.contree` file, which we'll use to visualise our tree, and the `.log` file which contains all the information that appeared on the terminal window.





