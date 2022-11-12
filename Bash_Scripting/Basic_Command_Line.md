# [GECO Viral Bioinformatics training](https://github.com/josephhughes/viral-bioinformatics-training)
* Monday 21st - Friday 25th November 2022 - Manila, Philippines

# Contents

- [GECO Viral Bioinformatics training](#geco-viral-bioinformatics-training)
- [Contents](#contents)
- [1: Basic Command Line](#1-basic-command-line)
  - [1.1: Tab Autocomplete](#11-tab-autocomplete)
  - [1.2: Exiting a program](#12-exiting-a-program)
  - [1.3 Move to front/end of line](#13-move-to-frontend-of-line)
  - [1.4 Reuse old commands](#14-reuse-old-commands)
- [2: Navigation in Linux](#2-navigation-in-linux)
  - [2.1: `pwd` (Print Working Directory)](#21-pwd-print-working-directory)
    - [Task 1](#task-1)
  - [2.2: `ls` (List)](#22-ls-list)
    - [Task 2](#task-2)
    - [Task 3](#task-3)
    - [Task 4](#task-4)
  - [2.3: `mkdir` (Make Directory)](#23-mkdir-make-directory)
    - [Task 5](#task-5)
    - [Task 6](#task-6)
  - [2.4: `cd` (Change Directory)](#24-cd-change-directory)
    - [Task 6](#task-6-1)
    - [Task 7](#task-7)


# 1: Basic Command Line
There are a number of handy commands and shortcuts that are useful to know before diving into the Linux command line. 

## 1.1: Tab Autocomplete
  When using the command line, often typing is the slowest part. Linux is awar of this and lets you use the tab button to autocomplete for certain filnames or directories. While typing in a filename, if you type the first few letters and hit the tab button, Linux will attempt to autocomplete the name for you. If it cannot do this, keep typing out the name as it is likely the first few characters are not enough to uniquely identify the file. This can be verified by hitting the tab button twice which will produce the following output:
  ```shell 
  kieran@linuxmachine:~$ cd D         
  Desktop/    Documents/  Downloads/
  ```
## 1.2: Exiting a program
  Sometimes you might want to exit a program if for example it is running for too long, or is stuck in an infinite loop. We can do this with either `cmd+c` on a mac or `ctrl+c` on windows.


## 1.3 Move to front/end of line
When typing a command, you might want to jump to the fron of the command if you have made a typo or want to edit the command. We can do this using `ctrl+a` to move to the front of a command and `ctrl+e` to move to the end.

## 1.4 Reuse old commands
Often we want to reuse commands we have already run before. in Linux you can do this using the up and down arrow keys on the keyboard to flick through the most recently used commands. This saves a lot of time typing, especially if you are writing and re-runnng scripts to check they work correctly.

# 2: Navigation in Linux
The file system of linux is organised as a hierarchy of files and directories(folders). The root directory is the top of the hierarchy with all other files and direstories in the operating system located below it.
![alt text](Images/filesystem.png)
When you login to your account on a linux machine, you will be placed into a directory named after your username (for example, if my username is kieran, my directory will be found at **'/home/kieran'** ). This is located inside another directory called home, which is contained within the root directory (which is called /). In order to use Linux via the terminal, it is important to know how to navigate around the operating system using commands.

## 2.1: `pwd` (Print Working Directory)
The first thing you might want to know when you enter the command line is where exactly you are in the operating system. The `pwd` is used for exactly that. The command stands for **"print working directory"** and will print the users current location.

 ```bash
kieran@linuxmachine:~$ pwd
/home/kieran
  ```

As we are in the home directory of my user, the command returns `/home/kieran`.

--------

### Task 1
Find your current directory using pwd.

--------

## 2.2: `ls` (List)
The next thing we might want to do is to have a look at what files and directories are in our home directory. We can do this using the `ls` command, which lists the contents of the current working directory (i.e where the user currently is). 

 ```bash
kieran@linuxmachine:~$ ls
anaconda3 test_file.txt 
```
The output of `ls` on my machine shows that I have a directory called **anaconda3**, and a file called **test_file.txt**. The output will vary depending on the contents of your home directory. `ls` can also be used with flags to change the output in various ways. Flags are specified by adding a `-` followed by a character that indicates the flag type. An example of an `ls` flag is the `-l` flag which prints each item in the list on a separate line. We can also use the -h flag to make the output (specifically any output relating to file sizes) more human readable:

 ```bash
kieran@linuxmachine:~$ ls -l -h
total 4.0K
drwxrwxr-x 28 kieran kieran 4.0K Oct 18 11:09 anaconda3
-rw-rw-r--  1 kieran kieran    0 Oct 30 13:14 test_file.txt
```

We can see that each file and directory is printed on its own line, along with some extra information about its user permissions, last edit dates and file sizes. 

Most Linux commands have optional flags and follow a similar pattern of use i.e:
`command_name [-flags] [parameters]`.  A full example of `ls` may look like `ls -l -h anaconda3`, where the output would be a listed print of all files and directories in the anaconda3 directory in a human readable form.

--------

### Task 2
Use `ls` to list the folders in your current directory.

### Task 3
Use `ls` to list each item in the directory in a new line.

### Task 4
Repeat task 3, but make the file sizes "human readable".

--------

## 2.3: `mkdir` (Make Directory)
The `mkdir` command is used to create a directory in Linux.
 Lets use it to make an example directory to navigate into. We do this by using `mkdir` followed by the name of the directory we wish to create:
```bash
kieran@linuxmachine:~$ mkdir example_directory
 ```

--------

### Task 5
Create 2 new directories using `mkdir`

### Task 6
List the contents of one of these new directories.

--------

## 2.4: `cd` (Change Directory)
Now lets try and navigate around the operating system and explore a bit. To do this we will need to use the `cd` command which allows us to move up or down the file system. At its most basic, `cd` works as follows:

 ```bash
kieran@linuxmachine:~$ cd directory_name
 ```

If the directory name is correct, then the command will move the user to that directory. We can check this has worked using `pwd`. 

 ```bash
kieran@linuxmachine:~$ cd example_directory/
kieran@linuxmachine:~/example_directory$ pwd
/home/kieran/example_directory
 ```

 Depending on the distro of Linux you are using, you might notice that the `~` before the `$` has changed to `~/example_directory`. This is actually equivalent to the output of `pwd`, with the exception that `~` is being used to represent `/home/kieran/`. In Linux systems, `~` is used to represent the users home directory. This means that if we ever want to quickly return to our home directory, we can do so with the following:

 ```bash
kieran@linuxmachine:~/example_directory$ cd ~
kieran@linuxmachine:~$ pwd
/home/kieran/
 ```

 So we can now enter a directory and return home using `~`, how do we move up to a directory above our current directory? In Linux, we can use `..` to indicate we want to move up a level in the hierarchy.
 
 ```bash
kieran@linuxmachine:~$ cd ..
kieran@linuxmachine:/home$ pwd
/home
 ```
 `pwd` shows that we are now in the home directory, which is indeed one directory above the user directory. We can mavigate back down to our home using either `cd ~` or `cd username` (`cd kieran` for me).

 While the examples here show moving up and down to folders that are directly above or below our working directory, `cd` can be given all sorts of filepaths. 

  ```bash
kieran@linuxmachine:~$ cd ../kieran/example_directory/
kieran@linuxmachine:~/example_directory$ pwd
/home/kieran/example_directory
```
This example is a bit unnecessary, but to summerise, we moved up one directory using `..`, then back down to our current directory with `/kieran`, then down again with  `/example_directory`. We could do the same thing using either ` cd /home/kieran/example_directory` or `cd ~/example_directory` or `cd example_directory` if we are in the home directory already. 

The path `/home/kieran/example_directory` is actually an example of a **absolute path**, meaning that the path begins at the root of the filesystem and ends at the destination. Absolute paths are handy when we know files are stored at a static location that is unlikely to change (configuration files are a good example of this) but since they require the whole path to be listed, they appear very long. As such, **relative paths** are often used. These identify the location of a file relative to either the current working directory (`cd example_directory` is an example of using a relative path) or relative to some symbol like `~` (again representing the users home directory) or `.` (representing the directory the user is currently in, i.e equivelent to the working directory). 

-----

### Task 6
Navigate to the root directory

### Task 7
Navigate from the root directory back to the home directory

-----
