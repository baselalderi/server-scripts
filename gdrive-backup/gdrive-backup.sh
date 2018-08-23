#!/bin/bash
PATH=/usr/sbin:$PATH # Make sure cron sees the gdrive executable

### Settings ###
GDBASE='ServerBackup' # Base backup directory in Google Drive
GDCONF='Conf' # Configs backup directory
GDWEB='Web' # Web backup directory

# Server configs directories 
CONFDIRS=(
	/etc/letsencrypt
	/etc/mysql
	/etc/nginx
	/etc/php
)

# Server web directories
WEBDIRS=(
	/opt/staging
	/opt/www
)

# MySQL Databases
MYSQLDBS=(
	DB1
	DB2
	DB3
)

MYSQLUN='root' # Username for using mysqldump
MYSQLPW='rootpassword' # Password for using mysqldump

CONFBUDAY='01' # Day of the month to backup server configs
### End Settings ###

# Get the datetime and use it to make a temp directory
DATETIME=$(date +%F-%H-%M-%S);
TMPDIR="/tmp/ub-$DATETIME";

# Get IDs for Base, Conf, and Web directories--if directories don't exist, create them
GDBASEID=$(gdrive list -q "name contains '$GDBASE' and mimeType contains 'folder'" --order "folder,name" | grep "$GDBASE" | awk '{print $1}');
if [[ "$GDBASEID" == "" ]]; then
	GDBASEID=$(gdrive mkdir $GDBASE -p 'root' | awk '{print $2}');
	GDCONFID=$(gdrive mkdir $GDCONF -p $GDBASEID | awk '{print $2}');
	GDWEBID=$(gdrive mkdir $GDWEB -p $GDBASEID | awk '{print $2}');
else
	GDCONFID=$(gdrive list -q "'$GDBASEID' in parents and mimeType contains 'folder'" --order "folder,name" | grep "$GDCONF" | awk '{print $1}');
	if [[ "$GDCONFID" == "" ]]; then GDCONFID=$(gdrive mkdir $GDCONF -p $GDBASEID | awk '{print $2}'); fi;

	GDWEBID=$(gdrive list -q "'$GDBASEID' in parents and mimeType contains 'folder'" --order "folder,name" | grep "$GDWEB" | awk '{print $1}');
	if [[ "$GDWEBID" == "" ]]; then GDWEBID=$(gdrive mkdir $GDWEB -p $GDBASEID | awk '{print $2}'); fi;
fi;

# Check if today's temp directory exists, and if not create it
if [[ ! -d "$TMPDIR" ]]; then mkdir $TMPDIR; fi;

# Configs backup
if [[ "$(date +%d)" == "$CONFBUDAY" ]]; then
    tar -zcvf $TMPDIR/conf-$DATETIME.tar.gz ${CONFDIRS[*]};

    UPLOADSUCCESS=0;
    until [[ "$UPLOADSUCCESS" == "1" ]]; do
    	gdrive upload $TMPDIR/conf-$DATETIME.tar.gz -p $GDCONFID;

    	# Adding "sleep 1s" so as to not piss of Google
    	if [[ "$?" == "0" ]]; then UPLOADSUCCESS=1; else sleep 1s; fi;
    done;

    # Keep the temp directory tidy
    rm $TMPDIR/conf-$DATETIME.tar.gz;
fi;

# Web backup
tar -zcvf $TMPDIR/web-$DATETIME.tar.gz ${WEBDIRS[*]} &&

mysqldump --user="$MYSQLUN" --password="$MYSQLPW" --opt --quick --single-transaction --skip-lock-tables --routines --triggers --events --databases ${MYSQLDBS[*]} | gzip -c > $TMPDIR/mysql-$DATETIME.gz;

UPLOADSUCCESS=0;
until [[ "$UPLOADSUCCESS" == "1" ]]; do
	gdrive upload $TMPDIR/web-$DATETIME.tar.gz -p $GDWEBID &&
	gdrive upload $TMPDIR/mysql-$DATETIME.gz -p $GDWEBID;

	# Adding "sleep 1s" so as to not piss of Google
	if [[ "$?" == "0" ]]; then UPLOADSUCCESS=1; else sleep 1s; fi;
done;

# Remove the temp directory
rm -rf $TMPDIR;