#!/bin/bash
#
# backup MySQL (wordpress) database using mysqldump
#

# set script parameters
#------------------------------------------------------------------------------

# number of backups to keep
num_daily_backups=10
num_monthly_backups=365

# database username
db_user=your_user_name

# database password
db_pwd=your-password

# database host
db_host=mysql_host

# database name
db_name=your_database_name

# prefix for filename backup (date of backup will be appended
file_prefix=prod-db
file_prefix_monthly=prod-monthly-db

# absoulute path to backup location (end with forwardslash)
backup_location=/home/your_username/webbackups/

#------------------------------------------------------------------------------


# delete backups older than days specified above
find $backup_location -name "${file_prefix}*" -mtime +$num_daily_backups -exec rm -f {} \;
find $backup_location -name "${file_prefix_monthly}*" -mtime +$num_monthly_backups -exec rm -f {} \;

filename=${backup_location}${file_prefix}-$(date +%Y%m%d).sql.gz
monthlyfilename=${backup_location}${file_prefix_monthly}-$(date +%Y%m).sql.gz

# dump to a gzip file
mysqldump -h$db_host -u$db_user -p$db_pwd -c $db_name --add-drop-table --complete-insert | gzip -c > $filename

# check for existence of monthly backup with size > 0
# only copy daily to monthly name if we haven't already done so this month
if [ ! -s $monthlyfilename ]
then
  cp $filename $monthlyfilename;
fi

exit 0

