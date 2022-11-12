# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines

# Contents

- [GECO Viral Bioinformatics training](#geco-viral-bioinformatics-training)
- [Contents](#contents)
- [1: File Creation and Manipulation](#1-file-creation-and-manipulation)
  - [1.1: `echo`](#11-echo)
    - [Task 1](#task-1)
  - [1.2: `touch`](#12-touch)
    - [Task 2](#task-2)
  - [1.3: `rm` (Remove)](#13-rm-remove)
  - [1.4: `nano` (Text Editor)](#14-nano-text-editor)
    - [Task 3](#task-3)
  - [1.5: `cat` (Concatenate)](#15-cat-concatenate)
    - [Task 4](#task-4)
  - [1.5: `cp` (Copy)](#15-cp-copy)
    - [Task 5](#task-5)
    - [Task 6](#task-6)
  - [1.6: `mv` (Move)](#16-mv-move)
    - [Task 7](#task-7)
    - [Task 8](#task-8)
  - [1.7: `head` and `tail`](#17-head-and-tail)
    - [Task 9](#task-9)
    - [Task 10](#task-10)
    - [Task 11](#task-11)
  - [1.8: Piping and Redirecting (`|`,`>`,`<`)](#18-piping-and-redirecting-)
    - [Task 12](#task-12)
    - [Task 13](#task-13)
  - [1.9: `sort`](#19-sort)
    - [Task 14](#task-14)
  - [1.10: `cut`](#110-cut)
    - [Task 15](#task-15)
  - [1.11: `uniq` (Unique)](#111-uniq-unique)
    - [Task 16](#task-16)
  - [1.12: `grep` (Global Regular Expression Print)](#112-grep-global-regular-expression-print)
    - [Task 17](#task-17)
    - [Task 18](#task-18)
  - [1.13: `sed` (Stream Editor)](#113-sed-stream-editor)
    - [Task 19](#task-19)
    - [Task 20](#task-20)
  - [1.14: `awk`](#114-awk)
    - [Task 21](#task-21)


# 1: File Creation and Manipulation
Much of using the command line involves creating and manipulating text files. In Linux there are a number of ways to do this varying from creating empty files, using command line text editors, slicing, dicing and parsing and much more. 

## 1.1: `echo`
The `echo` command is equivalent to the `print` command in programming languages like python. It simply prints anything given to it to the terminal like so:
```bash
kieran@linuxmachine:~$ echo hi
hi
```
While printing "hi" might not be particularly useful, it can also be used to print the values of enviroment variables like the system path:

```bash
kieran@linuxmachine:~$ echo $PATH
/home/kieran/.local/bin:
```


-----

### Task 1
Print the value of the home enviroment variable.

-----


## 1.2: `touch`
The `touch` command allows a user to create a file in a location by simply specifying the file name. The file will contain no contents, but will appear in the directory specified.

```bash
kieran@linuxmachine:~$ touch new_file.txt
```

-----

### Task 2
Create a new file with `touch` and place it in one of the directories you made earlier.

-----

## 1.3: `rm` (Remove)
The `rm` command is used to delete files or directories. The command is used as follows:

```shell
kieran@linuxmachine:~$  rm new_file.tx
```

If you need to delete a directory, you can use the `-r` flag, although when doing this be sure you know what you are deleting (The film Toy Story 2 was accidentally almost entirely accidentally deleted using a variation on this command). 


## 1.4: `nano` (Text Editor)
In linux, there are a number of text editors (`nano` and `vim` are two included examples) that allow the user to open files and type text on the command line. These operate similarly to traditional text editors you might use like Notepad, but often require the use of a number of key combinations(**macros**) to do common operations like save or even exit the editor. `nano` is an editor that is (relatively) easy to use. We can use `nano` to creat new text files, or open existing ones as follows:

```bash
kieran@linuxmachine:~$ nano new_file.txt
GNU nano 4.8                                                                                                          

Here is some text I want to save.


                                                                                             [ Welcome to nano.  For basic help, type Ctrl+G. ]
^G Get Help       ^O Write Out      ^W Where Is       ^K Cut Text       ^J Justify        ^C Cur Pos        M-U Undo          M-A Mark Text     M-] To Bracket    M-Q Previous      ^B Back           ^◀ Prev Word      ^A Home
^X Exit           ^R Read File      ^\ Replace        ^U Paste Text     ^T To Spell       ^_ Go To Line     M-E Redo          M-6 Copy Text     ^Q Where Was      M-W Next          ^F Forward        ^▶ Next Word      ^E End
```

`nano` displays the commonly used macros at the bottom of the interface. The user can otherwise type the contents of the file as they wish and save once they are done.

-----

### Task 3
Open a text file with `nano`, add some text, save the file and exit `nano`.

-----

## 1.5: `cat` (Concatenate)
Sometimes, you might wish to view the contents of a text file without opening it in a text editor. `cat` allows the user to do just that, and will print the contents of a file straight to the terminal. If we try the command on the file we created with nano, the result is as follows:

```bash
kieran@linuxmachine:~$ cat new_file.txt 
Here is some text I want to save
```
-----

### Task 4
Use `cat` to print the contents of the file you just made with `nano`.

-----

## 1.5: `cp` (Copy)
The `cp` command allows you to copy a file and make a new file with the same contents. The `-r` flag (standing for recursive) allows cp to work with directories as well as files.

```bash
kieran@linuxmachine:~$ cp sarscov2.gb other_gb_file.gb
```

-----

### Task 5
Use `cp` to make a copy of the text file you made with `nano`. 

### Task 6
Use `cp` to make a copy of the directory you created earlier.

-----

## 1.6: `mv` (Move)
The `mv` command allows you to move a file from one location to another. It can also be used to rename a file by moving it to the current directory but using a new filename.
To move a file:
```bash
kieran@linuxmachine:~$ mv sarscov2.gb ~/example_directory/sarscov2.gb
```
To rename a file:
```bash
kieran@linuxmachine:~$ mv sarscov2.gb sarscov2_gb_file.gb
```

-----

### Task 7
Use `mv` to move the text file into the directory you made a new copy of.

### Task 8
Use `mv` to rename the text file.

-----




## 1.7: `head` and `tail`
Often a file might be very large, so opening it all at once with `cat` or `nano` could take a very long time. As such, its convenient to look at the first or last N lines  of a file which can be done with the `head` and `tail` commands. The `-n` flag can be used to specify how many lines should be printed, otherwise the default is 10 lines.

```bash
kieran@linuxmachine:~$ head -n 5 owid-covid-data.csv
iso_code,continent,location,date,total_cases,new_cases,new_cases_smoothed,total_deaths,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million
AFG,Asia,Afghanistan,2020-02-24,5.0,5.0,,,0.122,0.122,
AFG,Asia,Afghanistan,2020-02-25,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-26,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-27,5.0,0.0,,,0.122,0.0,
```
```bash
kieran@linuxmachine:~$ tail -n 5 owid-covid-data.csv
ZWE,Africa,Zimbabwe,2022-10-27,257893.0,0.0,0.0,5606.0,15801.745,0.0,0.0
ZWE,Africa,Zimbabwe,2022-10-28,257893.0,0.0,0.0,5606.0,15801.745,0.0,0.0
ZWE,Africa,Zimbabwe,2022-10-29,257893.0,0.0,0.0,5606.0,15801.745,0.0,0.0
ZWE,Africa,Zimbabwe,2022-10-30,257893.0,0.0,0.0,5606.0,15801.745,0.0,0.0
ZWE,Africa,Zimbabwe,2022-10-31,257893.0,0.0,0.0,5606.0,15801.745,0.0,0.0
```

-----

### Task 9
Use `head` to display the first 5 lines of the owid-covid-data.csv file.

### Task 10
Use `tail` to display the last 3 lines of the owid-covid-data.csv file.

### Task 11
Use `tail` to display the last lines of the owid-covid-data.csv file after line 231630 (**hint** you can also use + with the `-n` flag ).

-----


## 1.8: Piping and Redirecting (`|`,`>`,`<`) 
We might want to perform a series of different commands on the command line. We can do this using the pipe (`|`) and redirection (`>`,`<`) operators when using different commands. A pipe takes the standard output of one command and sends it as the standard input of another command. Using our `head` and `tail` commands, we can extract lines 495-500 by piping the output of the `head` command into the input of the `tail` command like this:

```bash
kieran@linuxmachine:~$ head -n 500 owid-covid-data.csv | tail -n 5  
AFG,Asia,Afghanistan,2021-07-02,122156.0,1940.0,1509.143,5048.0,2970.086,47.169,36.693
AFG,Asia,Afghanistan,2021-07-03,123485.0,1329.0,1480.143,5107.0,3002.399,32.313,35.988
AFG,Asia,Afghanistan,2021-07-04,124748.0,1263.0,1504.0,5199.0,3033.108,30.708,36.568
AFG,Asia,Afghanistan,2021-07-05,125937.0,1189.0,1455.143,5283.0,3062.017,28.909,35.38
AFG,Asia,Afghanistan,2021-07-06,127464.0,1527.0,1472.286,5360.0,3099.144,37.127,35.797
```

Lets say we want to save the output of this into a file. we can do this using a redirect (`>`) like so:

```bash
kieran@linuxmachine:~$ head -n 500 owid-covid-data.csv | tail -n 5  > 5_rows.txt
```
The `>` takes the output that would normally be printed to the terminal and redirects it into a file called "5_rows.txt". If this file does not exist, the file is created and filled with the output. If the file already exists, the file will be wiped blank and filled with the contents. If we want to keep what is already in the file, we can use the `>>` operator to append to the file.

```bash
kieran@linuxmachine:~$ head -n 505 owid-covid-data.csv | tail -n 5  >> 5_rows.txt
```

To check whether we have appended the rows to the file, we can use `cat` to display the file contents:

```bash
kieran@linuxmachine:~$ cat 5_rows.txt 
AFG,Asia,Afghanistan,2021-07-02,122156.0,1940.0,1509.143,5048.0,2970.086,47.169,36.693
AFG,Asia,Afghanistan,2021-07-03,123485.0,1329.0,1480.143,5107.0,3002.399,32.313,35.988
...
AFG,Asia,Afghanistan,2021-07-10,132777.0,1191.0,1327.429,5638.0,3228.324,28.958,32.275
AFG,Asia,Afghanistan,2021-07-11,133578.0,801.0,1261.429,5724.0,3247.799,19.475,30.67
```

----

### Task 12
Use `head` to retrieve the first 10 lines of the owid-covid-data.csv file use the redirect operator to make a new file called 10_owid.csv.

### Task 13
Retrieve the first 100 lines of the owid-covid-data.csv and pipe the output to retrieve the last 10 lines, before redirecting this to a new file.

----

## 1.9: `sort`
The `sort` command allows for files to be sorted, and a number of flags can be used to specify how the sorting should be done. 2 useful flags when sorting formatted data like csv or tsv files are the `-t` flag which indicates the character that separates the columns and the `-k` flag which allows for column selection.

```bash
kieran@linuxmachine:~$ sort 5_rows.txt -t "," -k 11   
AFG,Asia,Afghanistan,2021-07-11,133578.0,801.0,1261.429,5724.0,3247.799,19.475,30.67
AFG,Asia,Afghanistan,2021-07-10,132777.0,1191.0,1327.429,5638.0,3228.324,28.958,32.275
AFG,Asia,Afghanistan,2021-07-09,131586.0,1473.0,1347.143,5561.0,3199.366,35.814,32.754
AFG,Asia,Afghanistan,2021-07-08,130113.0,1092.0,1413.857,5477.0,3163.552,26.551,34.376
AFG,Asia,Afghanistan,2021-07-05,125937.0,1189.0,1455.143,5283.0,3062.017,28.909,35.38
AFG,Asia,Afghanistan,2021-07-06,127464.0,1527.0,1472.286,5360.0,3099.144,37.127,35.797
AFG,Asia,Afghanistan,2021-07-03,123485.0,1329.0,1480.143,5107.0,3002.399,32.313,35.988
AFG,Asia,Afghanistan,2021-07-07,129021.0,1557.0,1480.286,5415.0,3137.001,37.857,35.991
AFG,Asia,Afghanistan,2021-07-04,124748.0,1263.0,1504.0,5199.0,3033.108,30.708,36.568
AFG,Asia,Afghanistan,2021-07-02,122156.0,1940.0,1509.143,5048.0,2970.086,47.169,36.693
```
By specifying the separator as a `,` and setting `-k 11`, we have sorted the file according to the 11th column of the csv file. By default the order is ascending, but the `-r` flag can be used to invert this behaviour to descending.

`sort` can also be used with the `-u` flag to make the sorted output unique (i.e it is similar to sorting a file and then piping the output to `uniq`)

----

### Task 14
Use `head` to retrieve the first 10 lines of the owid-covid-data.csv file and then sort the output on the 4th column.

----


## 1.10: `cut`
The `cut` command allows for rhe selection of sections of files (such as a column, byte, or field). Similar to `sort`, `cut` takes a delimiter/separator flag (`-d`) and a flag to specify which type of `cut` operation you want to use (`-c` for characters, `-f` for fields/named columns, and `-b` for bytes). 

```bash
kieran@linuxmachine:~$ cut -d "," -f 1,5 5_rows.txt
AFG,122156.0
AFG,123485.0
AFG,124748.0
AFG,125937.0
AFG,127464.0
AFG,129021.0
AFG,130113.0
AFG,131586.0
AFG,132777.0
AFG,133578.0
```
The `-f` flag takes lists of columns using `,`, or `-` so multiple columns can be selected. 

----

### Task 15
Use `head` to retrieve the first 10 lines of the owid-covid-data.csv file, then retrieve the 1st column and display it.

----

## 1.11: `uniq` (Unique)
`uniq` allows for filtering of duplicate parts of a file (but only where the lines follow each other). At its most basic, `uniq` with used with no flags will output only unique lines of a sorted file. We can see this in action by selecting the first column

```bash
kieran@linuxmachine:~$ cut -d "," -f 2 owid-covid-data.csv| sort | uniq

Africa
Asia
Europe
North America
Oceania
South America
continent
```
By sorting the continent column, duplicate continent labels can be filtered by `uniq` since they will appear after each other. Try the command again without the `sort` to see how this behaviour changes.

----

### Task 16
Use `head` to retrieve the first 1000 lines of the owid-covid-data.csv file (excluding the header), retrieve the 1st column and filter for unique entries.

----


## 1.12: `grep` (Global Regular Expression Print)
`grep` is a very useful command that searches for and prints lines that contain a specified pattern in a file. These patterns can be very simple (searching for a character, word or phrase) but can also when needed detect complex patterns using the regular expression (regex)syntax. Exploring the regex syntax could be its own tutorial, so instead it is more useful to look for websites that help build regular expressions for the information you want to extract (regexr.com is an example). For this example, we will filter a fasta file to only show the sequence header information (headers can be identified by the > character)

```bash
kieran@linuxmachine:~$ grep ">" sc2.fasta 
>NC_045512.2 Severe acute respiratory syndrome coronavirus 2 isolate Wuhan-Hu-1, complete genome
```

Another example would be extracting the gene names from genbank files. We also use the `-o` flag to print only the parts of the input that match the expression rather than the full line.

```bash
kieran@linuxmachine:~$ grep "gene=" sarscov2.gb| uniq
                     /gene="ORF1ab"
                     /gene="S"
                     /gene="ORF3a"
                     /gene="E"
                     /gene="M"
                     /gene="ORF6"
                     /gene="ORF7a"
                     /gene="ORF7b"
                     /gene="ORF8"
                     /gene="N"
                     /gene="ORF10"
```

Using a basic regular expression `'".*"' ` (This one captures all strings within "" parenthesis), we can take grep a little further and trim this output so that we only get the gene names rather than the genbank formated line.

```bash
kieran@linuxmachine:~$ grep "gene=" Datasets/sarscov2.gb |uniq | grep -o '".*"'               
"ORF1ab"
"S"
"ORF3a"
"E"
"M"
"ORF6"
"ORF7a"
"ORF7b"
"ORF8"
"N"
"ORF10"
```

`grep`  is one of the most powerful commands for processing text files in linux, and is especially useful when used in conjunction with other commands.

----
 
### Task 17
Extract the lines containing the paper titles in the sarscov2.gb file

### Task 18
Extract the lines from the owid-covid-data.csv file that are from the Philippines, sort by the number of cases per day and print the top row.

----

## 1.13: `sed` (Stream Editor)
`sed` is a command that allows for editing of a text stream. It allows for printing, deleting and replacing of regular expressions, words or characters in text streams like files. `sed` takes a string that specifies how the incoming text should be processed. For printing the `p` character can be used with a number (which indicates a line number) or a range (indicates a line range). By default the entire contents of the input stream will be printed, but this can be suppressed using the `-n` flag.

```bash
kieran@linuxmachine:~$ sed -n "1p" owid-covid-data.csv 
iso_code,continent,location,date,total_cases,new_cases,new_cases_smoothed,total_deaths,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_millioncomplete 

kieran@linuxmachine:~$ sed -n "1,5p" owid-covid-data.csv 
iso_code,continent,location,date,total_cases,new_cases,new_cases_smoothed,total_deaths,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million
AFG,Asia,Afghanistan,2020-02-24,5.0,5.0,,,0.122,0.122,
AFG,Asia,Afghanistan,2020-02-25,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-26,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-27,5.0,0.0,,,0.122,0.0,
```

The `d` character can be used to delete lines in a similar manner. Here we delete the first line of the file before piping it to head to show that the firt line is no longer the header. `-n` is not needed here since we are wanting everyting that has not been deleted.

```bash
kieran@linuxmachine:~$ sed "1d" owid-covid-data.csv | head -n 1
```
Important to note as well, `sed` does not be default change the contents of the original file, unless the `-i` flag is used.

The `s` character is used to indicate a string substitution, with slashes used to indicate the search term followed by the replacement term. 

```bash
kieran@linuxmachine:~$ head -n 1 owid-covid-data.csv | sed -n 's/location/Loc/p'    
iso_code,continent,Loc,date,total_cases,new_cases,new_cases_smoothed,total_deaths,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million
```

Numbers can be used after the last `/` to indicate what instance of the string should be changed (for example if you only want to substitute the second occurrence of a word). The `g` character can also be place here to indicate that the change should be made globally (be default, `sed` only changes the first instance). Regular expressions can be used with `sed` as well to capture more complex patterns to substitute.


----
 
### Task 19
Use `sed` to get lines 500-600 from the owid-covid-data.csv file and save them to a file.

 
### Task 20
Get the lines from the owid-covid-data.csv file that have GBR in them, substitute UK for United Kingdom, then save the output to another file.

----


## 1.14: `awk` 
`awk` is a command that takes a input file/stream, splits the input lines into fields, matches input lines to searchable patters (similar to `grep` and `sed`) and allows for operations to be carried out on them. `awk` takes a patter which specifies what operations should be carried out. The most basic `awk` pattern is just to print the contents of the input stream or file:


```bash
kieran@linuxmachine:~$ head owid-covid-data.csv | awk "{print}" 
iso_code,continent,location,date,total_cases,new_cases,new_cases_smoothed,total_deaths,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million
AFG,Asia,Afghanistan,2020-02-24,5.0,5.0,,,0.122,0.122,
AFG,Asia,Afghanistan,2020-02-25,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-26,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-27,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-28,5.0,0.0,,,0.122,0.0,
AFG,Asia,Afghanistan,2020-02-29,5.0,0.0,0.714,,0.122,0.0,0.017
AFG,Asia,Afghanistan,2020-03-01,5.0,0.0,0.714,,0.122,0.0,0.017
AFG,Asia,Afghanistan,2020-03-02,5.0,0.0,0.0,,0.122,0.0,0.0
AFG,Asia,Afghanistan,2020-03-03,5.0,0.0,0.0,,0.122,0.0,0.0
```
Here, we add a pattern to search for (GBR) which allows for lines with this pattern to be printed:

```bash
kieran@linuxmachine:~$ awk "/GBR/ {print}" owid-covid-data.csv  
GBR,Europe,United Kingdom,2020-01-30,,,,1.0,,,
GBR,Europe,United Kingdom,2020-01-31,2.0,2.0,,1.0,0.03,0.03,
...
GBR,Europe,United Kingdom,2020-02-04,8.0,0.0,,2.0,0.119,0.0,
```

By default `awk` splits fields by whitespace characters, but this can be changed by using the `-F` flag followed by the split character:


```bash
kieran@linuxmachine:~$ awk -F "," '/GBR/ {print $1}' owid-covid-data.csv 
GBR
GBR
...
GBR
GBR
```

`awk` is also flexible in that if/else conditions and loops can be used within the `awk` command:


```bash
kieran@linuxmachine:~$ awk -F "," '/GBR/ {if ($4=="2020-02-04") print}' owid-covid-data.csv 
GBR,Europe,United Kingdom,2020-02-04,8.0,0.0,,2.0,0.119,0.0,

kieran@linuxmachine:~$ awk 'BEGIN {i = 1; while (i < 6) { print i; ++i } }'
1
2
3
4
5
```

----
 
### Task 21
Use `awk` to get lines that contain "Philippines", and display the Date column.

----