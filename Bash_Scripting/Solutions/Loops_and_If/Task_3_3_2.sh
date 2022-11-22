#!/bin/bash
file=`head -n 500 Datasets/owid-covid-data.csv| cut -d "," -f 6`
total=0
for line in $file 
do  
    total=$(($line+$total))
done
echo $total Total Cases 