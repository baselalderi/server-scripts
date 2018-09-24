#!/bin/bash
PATH=/usr/sbin:$PATH # Make sure cron sees the gdrive executable

### Settings ###

GDRCLONEREMOTE='remote'; # Google Drive remote alias used by RClone

GDCONFDIR='Conf'; # Configs backup directory
GDWEBDIR='Web'; # Web backup directory

CONFBACKUPDAY='01'; # Day of the month to backup server configs

# Server configs directories 
CONFDIRS=(
	/etc/letsencrypt
	/etc/mysql
	/etc/nginx
	/etc/php
);

# Server web directories
WEBDIRS=(
	/opt/staging
	/opt/www
);

# MySQL Databases
MYSQLDBS=(
	DB1
	DB2
	DB3
);

MYSQLUN='root'; # Username for using mysqldump
MYSQLPW='rootpassword'; # Password for using mysqldump

### End Settings ###

# Get the datetime and use it to make a temp directory
DATETIME=$(date +%F-%H-%M-%S);
TMPDIR=/tmp/sb-$DATETIME;

echo "Starting Google Drive backup: $DATETIME";
rclone about $GDRCLONEREMOTE:

# Delete temp directory if it exists so we can start fresh
if [[ -d "$TMPDIR" ]]; then rm -rf $TMPDIR; fi;

# Create temp directory
mkdir $TMPDIR && echo "Created $TMPDIR";

# Configs backup
if [[ "$(date +%d)" == "$CONFBACKUPDAY" ]]; then
	echo "Starting '$GDCONFDIR' backup";

	tar -zcf $TMPDIR/conf-$DATETIME.tar.gz ${CONFDIRS[*]};

	rclone copy $TMPDIR $GDRCLONEREMOTE:$GDCONFDIR/$DATETIME && echo "- Finished '$GDCONFDIR' backup";

	# Tidy up the temp directory
	rm -rf $TMPDIR/*;
fi;

# Web backup
echo "Starting '$GDWEBDIR' backup";

tar -zcf $TMPDIR/web-$DATETIME.tar.gz ${WEBDIRS[*]} &&

mysqldump --user="$MYSQLUN" --password="$MYSQLPW" --opt --quick --single-transaction --skip-lock-tables --routines --triggers --events --databases ${MYSQLDBS[*]} | gzip -c > $TMPDIR/mysql-$DATETIME.gz;

rclone copy $TMPDIR $GDRCLONEREMOTE:$GDWEBDIR/$DATETIME && echo "- Finished '$GDWEBDIR' backup";

# Remove the temp directory
rm -rf $TMPDIR && echo "Removed $TMPDIR";