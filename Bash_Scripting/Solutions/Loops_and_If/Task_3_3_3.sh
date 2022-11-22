#Solution one using awk and an if (only works if there is only one set of paired reads)

#!/bin/bash
files=`ls /Users/kieranlamb/Documents/Philippines/Bash_Scripting/Datasets/fastq_data/paired_end`
# echo $files
first_file=`echo $files | awk -F " " '{print $1}'`
first_file_trimmed=` echo $first_file |awk -F "_" '{print $1,$2}'`

second_file=`echo $files | awk -F " " '{print $2}'`
second_file_trimmed=` echo $first_file |awk -F "_" '{print $1,$2}'`

if [ "$first_file_trimmed" = "$second_file_trimmed" ]
then
    echo "$first_file and $second_file are paired ends"
fi


##Solution using loops and substrings
#!/bin/bash
files=`ls /Users/kieranlamb/Documents/Philippines/Bash_Scripting/Datasets/fastq_data/paired_end`

for file in $files
do
    if [[ ($file == *"_1.fq"*) ]]
    then
        file_trimmed=${file%_1.fq}
    elif [[ ($file == *"_2.fq"*) ]]
    then
        file_trimmed=${file%_2.fq}
    fi

    for second_file in $files
    do
        if [[ ($second_file == *"_1.fq"*) ]]
        then
            second_file_trimmed=${second_file%_1.fq}
        elif [[ ($second_file == *"_2.fq"*) ]]
        then
            second_file_trimmed=${second_file%_2.fq}
        fi

        if [[ ($file_trimmed == $second_file_trimmed) && ($file == *"_1.fq"*) &&  ($second_file == *"_2.fq"*)]]
        then
            echo "$file and $second_file are paired ends"
            break
        fi
    done
done
