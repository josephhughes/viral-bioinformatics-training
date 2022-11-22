
name="alignment.fasta"

#Get file extension with awk
echo $name | awk -F "." '{print $2}'

#Get file extension with cut
echo $name | cut -d "." -f 2

#Get file extension with indexing
echo ${name#*.}

#Get file extension with indexing
echo ${name: -5}

echo ${name: 10}

#Print fasta
echo ${name: 10:5}

#Print fasta
echo ${name#*.}

#Also print fasta
echo ${name%.*}

#Also print fasta
echo ${name#alignment.}


i="Hello and Goodbye"
#TCheck string contains other string with wildcard
if [[ $i == *"Goodbye"* ]]
then
  echo "i contains goodbye"
else
  echo "i does not contain goodbye"
fi
