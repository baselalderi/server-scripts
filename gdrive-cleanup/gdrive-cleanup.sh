#!/bin/bash
PATH=/usr/sbin:$PATH # Make sure cron sees the gdrive executable

### Settings ###
GDBASE='ServerBackup'; # Base backup directory in Google Drive
GDCONF='Conf'; # Configs backup directory
GDWEB='Web'; # Web backup directory

CINT='4 months'; # Interval for rolling Configs cleanup
WINT='10 days'; # Interval for rolling Web cleanup

DATETIME=$(date +%F-%H-%M-%S);
CDATESTRING=ub-$(date --date="$CINT ago" +%F); # The Configs string gdrive will search for
WDATESTRING=ub-$(date --date="$WINT ago" +%F); # The Web string gdrive will search for

GDBASEID=$(gdrive list -q "name contains '$GDBASE' and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$GDBASE" | awk '{print $1}');
GDCID=$(gdrive list -q "'$GDBASEID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$GDC" | awk '{print $1}');
GDWID=$(gdrive list -q "'$GDBASEID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$GDW" | awk '{print $1}');

# Find FolderId's of directories to clean
CDEL=$(gdrive list -q "name contains '$CDATESTRING' and '$GDCID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$CDATESTRING" | awk '{print $1}');
WDEL=$(gdrive list -q "name contains '$WDATESTRING' and '$GDWID' in parents and mimeType contains 'folder'" --order "folder,name" --no-header | grep "$WDATESTRING" | awk '{print $1}');

# If FolderId's exist, delete the folders
if [[ -n "$CDEL" ]]; then gdrive delete -r $CDEL; fi;
if [[ -n "$WDEL" ]]; then gdrive delete -r $WDEL; fi;