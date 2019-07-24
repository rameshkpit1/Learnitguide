#!/bin/bash

filename=dockerimage.log
stats_file=counts.log

total_lines=`wc -l $filename | cut -f1 -d " "`
empty_lines=`grep -c ^$ $filename`
total_words=`wc -w $filename | cut -f1 -d " "`
total_numbers=`cat $filename | tr -cd [123456789] | wc -c`

cat > $stats_file << EOF
Following stats are calculated from the log file "$filename":
Total Number of lines : $total_lines
Total Number of Empty Lines : $empty_lines
Total Number of Numbers : $total_numbers
Total Number of words : $total_words

EOF
echo "Stats are written in file : $stats_file"
