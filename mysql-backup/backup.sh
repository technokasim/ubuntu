  GNU nano 4.8                                                                                                      backup.sh
#!/bin/bash
##this script will backup mysql and upload it to google drive
##directory name
dirname=$1;
##database name
database=$2;
##database username
dbuser=$3;
##database password
dbpass=$4;
## rclone remote name
rcloneRemoteName=$5;
##google drive folder name
gdrivefoldername=$6;
##condition to check folder exist or not
if [ ! -d "$dirname" ]
then
    ##create directory
    mkdir ./$dirname
    ##dump mysql database on server
    mysqldump -u $dbuser -p$dbpass $database | gzip>"./$dirname/$database($(date +\%Y_\%m_\%d_\%H)).sql.gz"
    ##wait for 10 seconds
    sleep 10
    ##upload it to google drive
    rclone copy "./$dirname/$database($(date +\%Y_\%m_\%d_\%H)).sql.gz" $rcloneRemoteName:$gdrivefoldername
    ##if folder already exist
else
    ##dump mysql database on server
    mysqldump -u $dbuser -p$dbpass $database | gzip>"./$dirname/$database($(date +\%Y-\%m-\%d-\%H)).sql.gz"
     ##wait for 10 seconds
    sleep 10
    ##upload it to google drive
    rclone copy "./$dirname/$database($(date +\%Y-\%m-\%d-\%H)).sql.gz" $rcloneRemoteName:$gdrivefoldername
    ##delete 10 days older file on server to save disk space(this command is optional)
    find ./$dirname -mtime +10 -type f -delete
fi
exit 0;
