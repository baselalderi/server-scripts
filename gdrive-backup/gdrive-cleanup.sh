#!/bin/bash
PATH=/usr/sbin:$PATH # Make sure cron sees the gdrive executable

### Settings ###
GDBASE='ServerBackup'; # Base backup directory in Google Drive
GDCONF='Conf'; # Configs backup directory
GDWEB='Web'; # Web backup directory

CINT='4 months'; # Interval for rolling Configs cleanup
WINT='10 days'; # Interval for rolling Web cleanup

CLEANLOGS=true; # Whether or not to clean up log files (true/false)
LOGSDIR='/path/to/logs'; # Path to logs directory (no trailing slash)

CDATESTRING=ub-$(date --date="$CINT ago" +%F); # The Configs string gdrive will search for
WDATESTRING=ub-$(date --date="$WINT ago" +%F); # The Web string gdrive will search for

GDBASEID=$(gdrive list -q "name contains '$GDBASE' and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$GDBASE" | awk '{print $1}');
GDCID=$(gdrive list -q "'$GDBASEID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$GDC" | awk '{print $1}');
GDWID=$(gdrive list -q "'$GDBASEID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$GDW" | awk '{print $1}');

# Find FolderId's of directories to clean
CDEL=$(gdrive list -q "name contains '$CDATESTRING' and '$GDCID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$CDATESTRING" | awk '{print $1}');
WDEL=$(gdrive list -q "name contains '$WDATESTRING' and '$GDWID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$WDATESTRING" | awk '{print $1}');

# If FolderId's exist, delete the folders
if [[ -n "$CDEL" ]]; then
	DELETESUCCESS=0;
	until [[ "$DELETESUCCESS" == "1" ]]; do
		gdrive delete -r $CDEL;

		if [[ "$?" == "0" ]]; then DELETESUCCESS=1; else sleep 1s; fi;
	done;
fi;

if [[ -n "$WDEL" ]]; then
	DELETESUCCESS=0;
	until [[ "$DELETESUCCESS" == "1" ]]; do
		gdrive delete -r $WDEL;

		if [[ "$?" == "0" ]]; then DELETESUCCESS=1; else sleep 1s; fi;
	done;
fi;

if [[ "$CLEANLOGS" == true ]]; then rm "$LOGSDIR"/gdrive-backup-"$WDATESTRING"*; rm "$LOGSDIR"/gdrive-cleanup-"$WDATESTRING"*; fi;