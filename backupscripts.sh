#!/bin/bash
#This script is used to create a backup of filesystem or folders to target location based on user inputs.

clear

#Files will be stored in the below format.
time=`date +%k.%M.%S | cut -f2 -d " "`
dateformat=`date +%F`
backupfiles=backup.$dateformat.$time.tgz

#Getting the user input of a folder or filesystem require backup.

echo -e "Enter the full path of the folder or filesystem you want to backup: \c"
read backupfolders
if [ ! -e $backupfolders ];
then
        echo -e "\n\nYou have typed incorrect path, So exiting from the backup script........\n"
        exit
fi

#Getting user input to store the files
echo -e "Enter the target path to store the backup files: \c"
read targetdir

if [ ! -e $targetdir ];
then
        echo -e "Backup Folder doesn't exist. Creating the Folder......"
        mkdir -p $targetdir

fi

#calculating the total size of the source folder and also checking free space available at the target location.
totalsize=`du -sk $backupfolders | awk '{print $1}'`
freespace=`df $targetdir | grep -v Filesystem | awk '{print $4}'`

#Checking free space available or not to store the data.
if [ $totalsize -le $freespace ];
then
        echo -e "Target location has enough free space, hence proceeding to store the data...\n"
        echo -e "Backup process started to take the backup $backupfolders. Please wait for a moment..."
        tar -czvf $targetdir/$backupfiles $backupfolders > /dev/null
        if [ $? -eq 0 ];
        then
           echo -e "\nBackup process is completed. Backup File is saved in $targetdir.\n"
        else
           echo -e "ERROR : Backup is failed\n"
        fi
else
        echo -e "ERROR : Target Location $targetdir doesnt have sufficient free space to store the data..\n"
fi
