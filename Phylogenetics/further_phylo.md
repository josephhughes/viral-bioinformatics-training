# Further Phylodynamics and Phylogeography

## Introduction

In this practical you will be briefly introduced to further phylodynamic and phylogeographic analyses that can be undertaken. This is in no way a complete tutorial, and should you want to recreate the analyses viewed here you should complete the tutorials available at https://beast.community/index.html. Instead, you will be introduced to some initial concepts, and the end results you can expect to achieve.

For this practical we will be using premade datasets and trees from rabies virus sequences from the Cosmopolitan AF1a_C1 lineage. 


## Tempest

Once you have your tree and the collection date associated with each sequence, you can do some further analysis! We first want to check if the data shows a temporal signal. We do this using Tempest, which can be downloaded from http://tree.bio.ed.ac.uk/software/tempest/ 

Tempest needs a tree and a set of dates to run.

Check the metadata file `~/Phylogenetics/AFb_C1_dates.txt` and make a note of the format the dates are written in.

Open tempest and, when prompted, select the rabies tree in the phylogenetics folder `~/Phylogenetics/AF1b_C1_aligned.fasta.contree`. 

Click `import dates` and select the metadata file `~/Phylogenetics/AF1b_C1_dates.txt`.

Select `Parse as calendar date` and enter the date format you noted in the first step.
Hint: press the question mark button next to the entry box to see how this should be written! 

You should see a list of dates appear beside the sequence IDs in Tempest. If you've parsed the dates correctly, the date for `RV2932` should be `2007.441095890411`.

We can now assess the temporal signal of the data. 

Click the `root-to-tip` tab, then select the box in the top left corner titled `best-fitting root`. Each sequence is now represented by a dot, indicating the divergence of the sequence from the root (or MRCA) over time. Sequences with more divergence than expected appear above the line, while sequences with less divergence than expected appear below the line. 

Click the `tree` tab. You'll notice that some of the branches are coloured red and blue. If you draw a box around the tip by clicking and dragging with your mouse, you'll highlight the tip. With the sequence highlighted, click back on the `root-to-tip` tab. The sequence you selected is now highlighted here too. 

Using the information here, and highlighting the sequences of interest, figure out:

**What do red branches mean?**
**What do blue branches mean?**

Tempest can also give initial predictions of the age of the root (the time the MRCA of all the sequences occured) and the rate of evolution, in substitutions per sute per year. In the `root-to-tip` tab, try to figure out:

**When was the MRCA of these sequences predicted to have been?**
**What is the estimate of evolutionary rate?**

**Do you think this data shows good temporal signal? Why, and what evidence backs this up?**


## BEAST

Setting up, running and interpreting BEAST is beyond the scope of this tutorial, as it can be very time consuming! For the purpose of this tutorial, we are going to assume we have completed our BEAST runs, found the most likely population and clock models, and that our run has 'converged' - meaning it is complete! Getting to grips with BEAST can take some time, so try to follow the online tutorials when you have a chance.

## SPREAD

BEAST runs can incorporate not only temporal information (dates) but also spatial information (coordinates). This allows us to assess the geographic spread over time, and estimate the origins of clusters and outbreaks.

SPREAD is a program that helps us accomplish this. We will not be running spread in this tutorial, but we will be interpreting the outputs. To learn how to use spread, check the tutorials on the BEAST page. 

SPREAD creates a `.kml` file, which we can open with Google Earth.

Open Google Earth Pro and go to File->Open. Select the kml file `~/Phylogenetics/AF1b_C1.kml`. This should then open in Google Earth.

Navigate to Tanzania, where you'll see a set of red lines. Near the top of the screen you should also see a time slider. Drag the time slider back to the start, and then press play (the little clock with the arrow). You should see a recreation of the spread of the lineage over time!

**What year is the root estimated to be?**
**When did the lineage spread to Pemba Island?**
**Is there any evidence of long distance transmission? What could be explanations for this?**


# Summary

Hopefully this tutorial has shown you some of the next steps you can take with your trees, and shown you some of the useful data and graphics you can create from it! To undertake any of these yourself, you'll need to spend some time practicing using BEAST.


