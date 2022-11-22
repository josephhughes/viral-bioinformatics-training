head -n 1 owid-covid-data.csv > $1
tail -n 100 owid-covid-data.csv >> $1
head -n 500 owid-covid-data.csv >> $1
sort -t "," -k 4 $1 > $2
echo "Task Completed!"
tail -n +1 $2 | wc -l 
