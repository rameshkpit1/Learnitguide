#!/bin/bash
#This script created to collect the complete system information with utilization report.

echo -e "\nSYSTEM INFORMATION"
echo "########################"
echo -e "\tServer Name\t:\t`hostname`"
echo -e "\tOperating System:\t`cat /etc/redhat-release`"
echo -e "\tKernel Version\t:\t`uname -r`"
echo -e "\tProduct Name\t:\t`dmidecode | grep "Product Name:" | head -1 | cut -f2 -d : | awk '{print $1,$2,$3}'`"
echo -e "\tPhysical Memory\t:\t`cat /proc/meminfo | grep MemTotal | cut -f2 -d ":" | awk '{print $1,$2}'`"
echo -e "\tSwap Memory\t:\t`cat /proc/meminfo | grep SwapTotal | cut -f2 -d ":" | awk '{print $1,$2}'`"
echo -e "\tCPU Model\t:\t`cat /proc/cpuinfo | grep "model name" | cut -f2 -d : | awk '{print $1,$2,$3,$4,$5,$6,$7}'`"
echo -e "\tNo of CPU's\t:\t`cat /proc/cpuinfo | grep "physical id" | sort -nr | uniq | wc -l`"
echo -e "\tNo of CPU Cores:\t`cat /proc/cpuinfo | grep "siblings" | sort -nr | uniq | wc -l`"
echo -e "\n"
echo "Disk detected:"
echo "--------------------"
fdisk -l | egrep Disk | egrep -v "label|identifier|mapper" | awk '{print $1,$2,$3,$4}' | cut -f1 -d ","
echo "--------------------"
echo "Server Uptime:"
echo "--------------------"
uptime
echo "--------------------"
echo "Users Logged in"
echo "--------------------"
w
echo "--------------------"

echo "Disk Utilization"
echo "--------------------"
df -h | egrep -v "tmpfs"
echo "--------------------"
echo "Memory Utilization"
echo "--------------------"
free -m | grep "Mem" | awk '{print "Memory - Free/total memory: " $4 " / " $2 " MB"}'
free -m | grep "Swap" | awk '{print "Swap - Free/total memory: " $4 " / " $2 " MB"}'
echo "--------------------"
echo "Performance Utilization"
echo "--------------------"
top -b |head -3
echo "--------------------"

echo "Top 3 Process Info"
echo "--------------------"
top -b |head -10 |tail -4
echo "--------------------"


echo "List of Listening Ports"
echo "--------------------"
echo -e `netstat -lnt | tail -n+3 | awk '{print $4}' | awk -F ":" '{print $NF}'  |sort -nr | uniq | tr "\n" " "\n`
