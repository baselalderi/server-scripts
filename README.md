# Server Scripts

A collection of scripts I use regularly.

**Note:** I've switched over to using RClone instead of GDrive in my Backup and Cleanup scripts. This was due to noticing too many `googleapi: Error 403: Rate Limit Exceeded, rateLimitExceeded` errors being logged whenever cron invoked GDrive. The errors seem to be related to Google's API limits as well as GDrive not implementing exponential backoff during uploads (if I'm wrong about this, please let me know). So far, RClone has proved to be more reliable and, to date, has shown no errors during automated backups.

### Contents:

| Script 							| Directory				| Notes 			|
|-----------------------------------|-----------------------|-------------------|
| 1. GDrive Backup/Cleanup Scripts 	| [gdrive-backup][1] 	| See [README][2] 	|
| 2. RClone Backup/Cleanup Scripts 	| [rclone-backup][3] 	| See [README][4] 	|
| 3. Deployment Scripts 			| TBD 					| TBD 				|

### To Do:
- [X] GDrive backup script (using [GDrive][5])
- [X] GDrive script improvement: create backup directories if they don't exist
- [X] GDrive cleanup script
- [X] RClone backup/cleanup (using [RClone][6])
- [ ] Deployment scripts (using RSync)

[1]: gdrive-backup/
[2]: gdrive-backup/README.md
[3]: rclone-backup/
[4]: rclone-backup/README.md
[5]: https://github.com/prasmussen/gdrive
[6]: https://github.com/ncw/rclone/