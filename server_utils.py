#!/usr/bin/python
#This script is created to report the CPU Utilization, CPU Load Average and Memory Utilization with threshold value set to ensure the resources are not utilized upto the critical / warning level.
#Also it generates the Top 15 High CPU and Memory Consuming process in json format.
#Created : Selvakumar Viswanathan

from __future__ import print_function
import subprocess

# Threshold values
cpu_threshold = 60
mem_threshold = 80

#Process information storing logs as json format.
cpu_file_output = "high_cpu_usage.json"
mem_file_output = "high_memory_usage.json"

### Finding CPU Utilization ###

cpu = "top -b -n1 | grep -i 'Cpu(s)'"
cpu_op = subprocess.check_output(cpu,shell=True).strip()

### Finding Server Average Load ###

load = "uptime | awk '{print $(NF-2)" "$(NF-1)" "$(NF-0)}'"
load_op = subprocess.check_output(load,shell=True).strip()

### Finding Memory Utilization ###

mem = "top -b -n1 | grep -i 'KiB Mem'"
mem_op = subprocess.check_output(mem,shell=True).strip()

## Clearing screen

subprocess.call("clear")

## Outputs
print("----------------------")
print("Server monitoring tool")
print("----------------------")
print("CPU Utilization: ",cpu_op,end='\n\n')
print("Load Average: ",load_op,end='\n\n')
print ("Memory Utilization: ",mem_op,end='\n\n')
print("--------------------------------------------------------------------------------------------------",end="\n\n")

# Finding the percentage of CPU system usage value

cpu_value = "ps -eo pcpu | sort -k 1 -r | grep -v ""%CPU"" | awk ' {sum+=$1} END {print sum}'"
cpu_sy_op = subprocess.check_output(cpu_value,shell=True).strip()

cpu_threshold = float(cpu_threshold)
cpu_sys_usage = float(cpu_sy_op)

#Checking the CPU usage percentage with threshold value set (cpu_threshold)
if cpu_sys_usage < cpu_threshold:
 print("CPU Utilization - OK",end="\n\n")

else:
 print("CPU Utilization - WARNING",end="\n")
 print("(Top 15 High CPU Consuming Process are written in file -",cpu_file_output,")",end="\n\n")
 process_list = """ps -eo pcpu,pid,user,comm | sort -k 1 -r | grep -v "%CPU" | head -15 | python -c 'import json, fileinput; print json.dumps({"Highly_CPU_consumption_process":[dict(zip(("Percentage", "Parent Process ID", "Owner", "Command"), l.split())) for l in fileinput.input()]}, indent=2)'"""
 ls_proc = subprocess.check_output(process_list,shell=True).strip()
 outfile = open(cpu_file_output,'w')
 print (ls_proc, file=outfile )


#Checking Load Average is normal or overloaded.

cpu_load_avg = "uptime | awk '{print $(NF-2)}' | cut -f1 -d ','"
cpu_load_avg_op = subprocess.check_output(cpu_load_avg,shell=True).strip()

no_cpus = "nproc"
no_cpus_op = subprocess.check_output(no_cpus,shell=True).strip()
cpu_load_avg_op = float(cpu_load_avg_op)
no_cpus_op = float(no_cpus_op)

if cpu_load_avg_op <= no_cpus_op:
 print("Load Average - OK",end="\n\n")

else:
 print("Load Average : WARNING : ",load_op,end="\n\n")

# Filtering Memory usage value

mem_value = "ps -eo pmem | sort -k 1 -r | grep -v ""%MEM"" | awk ' {sum+=$1} END {print sum}'"
mem_sy_op = subprocess.check_output(mem_value,shell=True).strip()

mem_threshold = float(mem_threshold)
mem_sy_op = float(mem_sy_op)

#Checking the Memory usage percentage with threshold value set (mem_threshold)

if mem_sy_op < mem_threshold:
 print("Memory Utilization - OK",end="\n\n")

else:
 print("Memory Utilization - WARNING",end="\n")
 print("(Top 15 High Memory Consuming Process are written in file -",mem_file_output,")",end="\n\n")
 mem_list = """ps -eo pmem,pid,user,comm | sort -k 1 -r | grep -v "%MEM" | head -15 | python -c 'import json, fileinput; print json.dumps({"Highly_Memory_consumption_process":[dict(zip(("Percentage", "Parent Process ID", "Owner", "Command"), l.split())) for l in fileinput.input()]}, indent=2)'"""
 ls_mem = subprocess.check_output(mem_list,shell=True).strip()
 outfile = open(mem_file_output,'w')
 print (ls_mem, file=outfile )
