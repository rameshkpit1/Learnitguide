#!/bin/bash

#This script is created to extend the rootlv automatically if it exceeds threshold value set below

#Threshold value of root filesystem set to 80%, change it if required.
threshold_value="80"

#Bydefault, defined 20% to be extended. Change it if required.
extend_value="20"

#Finding usage of root volume
usage=`df -h / | grep / | awk '{print $5}' | cut -f1 -d %`

#Finding lvname of / filesystem
lvname=`df -h / | grep / | awk '{print $1}' | cut -f2 -d "-"`

#Finding vgname of / filesystem
vgname=`df -h / | grep / | awk '{print $1}' | cut -f4 -d / | cut -f1 -d "-"`

#Calculating the total size
totalsize=`df -h / | grep / | awk '{print $2}' | cut -f1 -d G`
totalsize_mb=`echo "($totalsize * 1024)" | bc`

#finding rootvg free space
vgfreespace=`vgs | grep $vgname | awk '{print $7}' | cut -f1 -d .`

#Calculating the size to be extended as per the extend_value set.
extend_size_mb=`echo "($totalsize_mb / 100) * $extend_value " | bc`

#converting the extending size in PE.

total_free_pe=`vgdisplay $vgname| grep -i "Free  PE" | awk '{print $5}'`
pe_size=`vgdisplay $vgname| grep -i "PE Size" | awk '{print $3}' | cut -f1 -d .`
extend_pe=`echo "($extend_size_mb / $pe_size) " | bc`


if [ $usage -le $threshold_value ];
then
   echo "Filesystem is not reached upto the threshold defined - $threshold_value%"
else
   if [ $extend_pe -le $total_free_pe ];
   then
     lvextend -l+$extend_pe /dev/mapper/$vgname-$lvname -r > /dev/null
     if [ $? -eq 0 ];
     then
      echo "Filesystem got extended by $extend_size_mb Mb"
      df -h /
     fi
   else
     echo "VolumeGroup : $vgname, doesnt have $extend_size_mb Mb free space"
   fi
fi
