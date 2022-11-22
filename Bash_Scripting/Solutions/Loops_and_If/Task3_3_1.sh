
number_of_files=`ls -l $1 | wc -l`
echo There are $number_of_files files in this directory
for file in *.fq
do
    reads=`wc -l $file | awk '{print $1}' `
    #Fastq files have 4 lines per read, so can divide by 4
    reads=$(($reads/4))
    echo $file has $reads reads.
done
