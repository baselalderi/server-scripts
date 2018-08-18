# Server Scripts

A collection of scripts I use regularly.

### Google Drive Backup:

I'll start off with a short bash script I wrote to back up some things from my development server onto Google Drive. To do so, I'm using the excellent [Google Drive CLI Client (GDrive)][1].

To get GDrive installed, locate the binary specific to your system then download it. For me (using 64-bit Ubuntu), the command was:

`curl -o /usr/sbin/gdrive -L "https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download"`

Then make GDrive executable: `chmod +x /usr/sbin/gdrive`

Last, you need to authenticate GDrive and give it access to your Google Drive account. To do that, run `gdrive list` and follow the instructions to obtain an OAuth token. 

Now you can use the Google Drive backup script.

#### Schemas:

Being a bit lazy, I put 2 different backup schemas in one file so I can only add one command to my crontab. If that's not ideal (and it's probably not), the script can be easily split off to accommodate multiple backup schemas.

For the time being, I have my web and database files backing up every day while my server configs are backing up once a month. I do this by enclosing the server configs part of the script in a simple conditional (`if [[ "$(date +%d)" == "01" ]]`) that only runs if it's the 1st day of the month.

#### Settings:

- GDBASE: The base folder where you'll store your backups<sup>[1](#1)</sup>
- GDCONF: The folder in which server configs are stored
- GDWEB: The folder in which web files and database dumps are stored
- CONFDIRS: The server config directories you want to backup, one directory per line
- WEBDIRS: The web directories you want to back up, one directory per line
- MYSQLDBS: The MySQL databases you want to dump, one database per line
- MYSQLUN: The MySQL username you want mysqldump to use
- MYSQLPW: The MySQL password you want mysqldump to use<sup>[2](#2)</sup>
- CONFBUDAY: The day of the month you want the script to backup server configs<sup>[3](#3)</sup>

Notes:
1. <a name="1"></a>If GDBASE doesn't already exist in Google Drive, the backup script will create it in Google Drive's root directory.
2. <a name="2"></a>You might not want to leave your MySQL password written in plain text inside this script. An alternative would be to set it in your `my.cnf` config file. See [here][3] for some more information.
3. <a name="3"></a>Example: if you want to back up your server configs on the 5th of every month, use `CONFBUDAY='05'`. Don't forget the leading zero.

#### Cron/Logging:

If you're like me, you want to automate the backup script and log its output in one easy step. With such a simple script, cron provides an excellent means to doing just that. Here's what I use in my crontab:

`30  1   *   *   *   /path/to/gdrive-backup.sh > /path/to/gdrive-backup-$(date +\%F-\%H-\%M-\%S).log 2>&1`

Now the script runs every morning at 1:30AM, and logs the output to a unique (timedated) file.

### To Do:
- [X] Google Drive backup script (using [GDrive][1])
- [X] Google Drive backup improvement: create Google Drive directories if they don't already exist
- [ ] Deployment script with rsync
- [ ] Google Drive file sync (using [RClone][2])

[1]: https://github.com/prasmussen/gdrive
[2]: https://github.com/ncw/rclone/
[3]: https://stackoverflow.com/a/9293090