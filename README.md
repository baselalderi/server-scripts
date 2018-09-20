# Server Scripts

A collection of scripts I use regularly.

**Note:** I've stopped working on the Google Drive Backup/Cleanup scripts as I've noticed too many `googleapi: Error 403: Rate Limit Exceeded, rateLimitExceeded` errors being logged. The errors seem to be related to Google's API limits as well as GDrive not implementing exponential backoff (if I'm wrong about this, please let me know). That said, in order to achieve worry-free and fully-automated cloud backups, I'll be switching over to RClone as it's reported to be more reliable when used within cron'd scripts.

### Contents:

| Script 							| Directory				| Notes 			|
|-----------------------------------|-----------------------|-------------------|
| 1. Google Drive Backup Script 	| [gdrive-backup][1] 	| See [README][2] 	|
| 2. Google Drive Cleanup Script 	| [gdrive-cleanup][3] 	| See [README][4] 	|
| 3. Google Drive File Sync 		| TBD 					| TBD 				|
| 4. Deployment Scripts 			| TBD 					| TBD 				|

### To Do:
- [X] Google Drive backup script (using [GDrive][5])
- [X] Script improvement: create Google Drive directories if they don't exist
- [X] Google Drive cleanup script
- [ ] Google Drive file sync (using [RClone][6])
- [ ] Deployment scripts (using RSync)

[1]: gdrive-backup/
[2]: gdrive-backup/README.md
[3]: gdrive-cleanup/
[4]: gdrive-cleanup/README.md
[5]: https://github.com/prasmussen/gdrive
[6]: https://github.com/ncw/rclone/