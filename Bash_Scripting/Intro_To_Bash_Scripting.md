# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines

# Contents

- [GECO Viral Bioinformatics training](#geco-viral-bioinformatics-training)
- [Contents](#contents)
- [1: Bash Scripting](#1-bash-scripting)
  - [1.1: Creating a bash script](#11-creating-a-bash-script)
    - [Task 1](#task-1)
  - [1.2: Storing command outputs as variables](#12-storing-command-outputs-as-variables)
  - [1.3: Accepting Arguments](#13-accepting-arguments)
  - [1.4: Loops](#14-loops)
    - [1.4.1: `for` Loop](#141-for-loop)
      - [Task 2](#task-2)
      - [Task 3](#task-3)
    - [1.4.2: `while` Loop](#142-while-loop)
    - [1.4.3: `until` Loop](#143-until-loop)
      - [Task 4](#task-4)
  - [1.5: `if else` Statements](#15-if-else-statements)
    - [Task 5](#task-5)
- [2: Quality Control Bash Script](#2-quality-control-bash-script)
    - [Task 6](#task-6)
    - [Task 7](#task-7)


# 1: Bash Scripting
Often bash scripts are created as a way to automate tasks. Bash scripts are small files that contain a series of bash commands and can be run from the command line. The scripts can take arguments like filenames, can perform repeated operations using loops, and can allow for easily reproducible execution of operations.

## 1.1: Creating a bash script
A bash script can be made by creating a textfile (using a text editor such as `nano`) and saving the file with a file ending of `.sh` to indicate that the file is a bash script. Bash scripts need to know the location of the bash interpreter (typically located in the `/bin/bash` directory) in order to be run. `#!/bin/bash` (i.e `#!/bash_location`) is placed at the top of the file to tell the script where to be run from. Bash scripts also need to be made executable, which allows them to be run from the command line. We can do this by using the `chmod` command which allows the user to change the permissions of a file. For our purposes, we want to make the file executable by the current user, so we can simply run `chmod` as follows:

```bash
kieran@linuxmachine:~$ chmod +x bash_script_name.sh 
```

The `+x` tells `chmod` that we wish to make the script executable, but there are many more permissions that can be added or removed by `chmod` such as who can edit the file, read it or execute it. Below is an example of a simple bash script to print hellow world

```bash
#!/bash_location
echo hello world
```

To run the bash script from the command line, we use the `./` notation which indictes to the shell that this command is a file to execute.


```shell
kieran@linuxmachine:~$ ./bash_script.sh
hello world
```


### Task 1
Create a bash script, make it executable and then run it from the command line.

## 1.2: Storing command outputs as variables
In bash scripts, we sometimes want to store the contents of our commands not as other files, but as variables in the script. We can do this using the ` ` ` parenthesis to indicate that the command is to be run and stored at a variable.

```bash
#!/bash_location
csv_file=`cat owid-covid-data.csv`  
echo $csv_file
```

## 1.3: Accepting Arguments
Bash scripts allow for passing in Arguments like file names to the scripts. We can do this by calling our scripts as normal, but adding the parameters after the filename spaced apart as follows:

```shell
kieran@linuxmachine:~$ ./bash_script.sh arg_1 arg_2
```

To access these arguments in the script, Bash splits the argument sting by spaces and allocates numbers to each argument

```bash
#!/bash_location
echo $1
echo $2
```

This script would then execute as follows:

```shell
kieran@linuxmachine:~$ ./bash_script.sh arg_1 arg_2
arg_1
arg_2
```

## 1.4: Loops
Loops are a fundamental aspect of most programming languages, and are necessary for automating tasks. Loops in bash cpome in 3 different forms: `for`, `while` and `do` loops.

### 1.4.1: `for` Loop
`for` loops are typically used when an operation is to be repeated a known number of times. This can used when theres a list of items, a directory of files, or a simple range of numbers.

```bash
#!/bash_location

##A bash for loop through a list of names
names='Kieran Dan John'
for name in $names
do
  echo $name
done

##A bash for loop through files that end with .fq in the directory fastq_sets
for file in fastq_sets/*.fq
do
  echo $file
done

##A bash for loop through the number range 1-3
for number in {1..3}
do
  echo $number
done

```

----
 
#### Task 2
 Make a bash script that uses a `for` loop to loop through the files in the current directory and print their line count.


#### Task 3
Make a bash script that uses a `for` loop to print numbers from 50-55.

----

### 1.4.2: `while` Loop
`while` loops can be used when an action should be repeated until a given condition is met. Common conditions in `while` loops are less than (denoted by `-lt`), greater than (`-gt`), equal to (`-eq`), greater than or equal to (`-ge`) and less than or equal to (`-le`). Arithmetic operations in bash must be done using either double brackets `((arithmetic))`, the `expr` command, or the `let` command. Here we use double brackets to increment the value of `i` so that the loop does not run forever.

```bash
#!/bash_location

##A while loop that prints the value of i while is <10
i=1
while [ $i -lt 10 ]
do
  echo $i
  ((i++))
done
```
For arithmentic that includes a decimal point, the result must be piped to the `bc` command which allows for the processing of floating point/decimal numbers.

```bash
#!/bash_location

##A while loop that prints the value of i while is <10
i=1
i=`$(($i+1.2)) | bc`
echo $i
```

### 1.4.3: `until` Loop
The `until` loop is identical to the while, and is mostly a semantic change to make the bash script easier to understand. The example below produces the same output as the `while` loop, but since we are looping until `i>=10`, we need to change our comparison operator to `-ge` instead of `-lt`

```bash
#!/bash_location

##A while loop that prints the value of i while is <10
i=1
until [ $i -ge 10 ]
do
  echo $i
  ((i++))
done
```

---

#### Task 4
Make a bash script that uses a `while` or `until` loop to print the line count of 2 files in the current directory.

----


## 1.5: `if else` Statements
As we demonstrated briefly with the `awk` command, sometimes we will want to complete certain task only if a condition is met. To do this in a bash script, we use `if` statements. Similar to the `while` condition, an `if` condition will only execute the commands if the condition is met. All if statements begin with `if`, followed by the condition. If there are multiple conditions, an `elif` or an `else` statement can be used to capture this. All if statments are concluded with a `fi` statement.

```bash
#!/bash_location

##An if condition that prints "i == 1" if i == 1
i=1
if [ $i -eq 1 ]
then
  echo "i == 1"
else
  echo "i != i"
fi

```
---

### Task 5
Make a bash script that loops through each file in the current directory, and prints name if the file ends with `.md`.

----


# 2: Quality Control Bash Script
Now we can use the skills from above to make a script to automate some quality control for a set of fastq files. We are going to use the `FastQC` and `TrimGalore!` package to run some quality control checks on our sequences. `As a reminder, TrimGalore!` is a `perl` package that links together the `cutadapt` and `fastqc` packages to make a pipeline that trims sequence reads of their adaptor sequences and removes low quality reads. We can call the package as follows:

```bash
kieran@linuxmachine:~$ trim_galore [-flags] [-files]
```
`TrimGalore!` only runs `fastqc` on the trimmed output files, so we may also want to run `fastqc` on the files before they are trimmed.


```bash
kieran@linuxmachine:~$ fastqc filename
```

`TrimGalore!` will automatically check for adaptor type, but this can be specified with the `--illumina`, `--nextera` or `--small_rna` flags.  

---

### Task 6
Make a bash script that loops through each file in the Datasets/fastq_data, checks if the file is illumina or nextera based on the name, runs `fastqc` on the files, then runs `trim_galore` and uses the correct parameters based on the filetype.

### Task 7 
Do the same as above (except autodetect adaptors can be used here), this time with the files in the Datasets/fastq_data/paired_end which are paired end sequence reads.

----