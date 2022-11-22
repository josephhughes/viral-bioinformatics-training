for file in Datasets/fastq_data/paired_end/*.fq
do
    current_directory=`pwd`
    if [[ ($file == *"_1.fq"*) ]]
    then
        file_trimmed=${file%_1.fq}
        fastqc -o $current_directory $file
        trim_galore --fastqc --paired -o $current_directory $file_trimmed"_1.fq" $file_trimmed"_2.fq" 
    elif [[ ($file == *"_2.fq"*) ]]
    then
        fastqc -o $current_directory $file
    fi
done