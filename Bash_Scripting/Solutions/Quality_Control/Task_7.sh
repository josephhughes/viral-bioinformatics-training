for file in Datasets/fastq_data/*.gz
do
    if [[ $file == *"illumina"* ]]
    then
        fastqc $file
        trim_galore $file --illumina --fastqc
    elif [[ $file == *"nextera"* ]]
    then
        fastqc $file
        trim_galore $file --nextera --fastqc
    elif [[ $file == *"small_rna"* ]]
    then
        fastqc $file
        trim_galore $file --small_rna --fastqc
    fi
done