#!/bin/bash
#
# backup www (or any) directory
#
# 

# set script parameters
#------------------------------------------------------------------------------

# number of backups to keep
num_daily_backups=10
num_monthly_backups=365

# prefix for filename backup (date of backup will be appended)
file_prefix=prod-www
file_prefix_monthly=prod-monthly-www

# absolute path to the directory you want to backup (will also backup subdirs)
directory_to_backup=/home/your_username/public_html

# absoulute path to backup location (with trailing forwardslash)
backup_location=/home/your_username/webbackups/

#------------------------------------------------------------------------------

# delete backups older than days specified above
find $backup_location -name "${file_prefix}*" -mtime +$num_daily_backups -exec rm -f {} \;
find $backup_location -name "${file_prefix_monthly}*" -mtime +$num_daily_backups -exec rm -f {} \;

filename=${backup_location}${file_prefix}-$(date +%Y%m%d).tgz
monthlyfilename=${backup_location}${file_prefix_monthly}-$(date +%Y%m).tgz

# add multiple exclude switches to exclude stuff:  --exclude='patter*' --exclude='file2'
tar -czf $filename -C $directory_to_backup . 

# check for existence of monthly backup with size > 0
# only copy daily to monthly name if we haven't already done so this month
if [ ! -s $monthlyfilename ]
then
  cp $filename $monthlyfilename;
fi

exit 0 
