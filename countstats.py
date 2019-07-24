#!/usr/bin/python
from __future__ import print_function
import subprocess


total_lines = "wc -l dockerimage.log | cut -f1 -d ' '"
cmd1 = subprocess.Popen(total_lines,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output1 = cmd1.communicate()[0]

empty_lines = "grep -c ^$ dockerimage.log"
cmd2 = subprocess.Popen(empty_lines,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output2 = cmd2.communicate()[0]

total_numbers = "cat dockerimage.log | tr -cd [123456789] | wc -c"
cmd3 = subprocess.Popen(total_numbers,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output3 = cmd3.communicate()[0]

total_words = "wc -w dockerimage.log | cut -f1 -d ' '"
cmd4 = subprocess.Popen(total_words,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
output4 = cmd4.communicate()[0]

outfile = open('counts_python.log','w')
outfile.write('\nFollowing stats are calculated from the log file : dockerimage.log\n\n')
print ( "Total Number of Lines: ",output1, file=outfile )
print ( "Total Number of Empty Lines: ",output2, file=outfile )
print ( "Total Number of Numbers: ",output3, file=outfile )
print ( "Total Number of words: ",output4, file=outfile )

print ("Stats are written in file : counts_python.log")
