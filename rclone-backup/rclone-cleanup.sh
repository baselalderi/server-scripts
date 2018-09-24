#!/bin/bash
PATH=/usr/sbin:$PATH # Make sure cron sees the gdrive executable

### Settings ###

GDCONFDIR='Conf'; # Configs backup directory
GDCONFDELINT='4M'; # Interval for rolling Configs cleanup (RClone --min-age suffix)

GDWEBDIR='Web'; # Web backup directory
GDWEBDELINT='10d'; # Interval for rolling Web cleanup (RClone --min-age suffix)

CLEANLOGS=true;  # Whether or not to clean up log files (true/false)
LOGSDIR='/path/to/logs'; # Path to logs directory (don't use a trailing slash)
LOGSDELINT='7 days'; # Interval for rolling log cleanup (Linux date format)

### End Settings ###

LOGSDATESTRING=$(date --date="$LOGSDELINT ago" +%F);

echo "Starting archive cleanup: $(date +%F-%H-%M-%S)";
rclone about gd:;

# Configs cleanup
echo "Cleaning '$GDCONFDIR' archives";

CONFARRAY=($(rclone ls gd:$GDCONFDIR --min-age $GDCONFDELINT | awk '{print $2}' | grep -oP '^[^/]*' | tr ' ' '\n' | sort -u | tr '\n' ' '));

if [[ -n "$CONFARRAY" ]]; then
	for LOCATION in "${CONFARRAY[@]}"; do
		rclone purge gd:$GDCONFDIR/$LOCATION --drive-use-trash=false && echo "- Deleted $GDCONFDIR/$LOCATION";
	done;
else
	echo "- No matching archives found in '$GDCONFDIR'";
fi;

# Web cleanup
echo "Cleaning '$GDWEBDIR' archives";

WEBARRAY=($(rclone ls gd:$GDWEBDIR --min-age $GDWEBDELINT | awk '{print $2}' | grep -oP '^[^/]*' | tr ' ' '\n' | sort -u | tr '\n' ' '));

if [[ -n "$WEBARRAY" ]]; then
	for LOCATION in "${WEBARRAY[@]}"; do
		rclone purge gd:$GDWEBDIR/$LOCATION --drive-use-trash=false && echo "- Deleted $GDWEBDIR/$LOCATION";
	done;
else
	echo "- No matching archives found in '$GDWEBDIR'";
fi;

# Log cleanup
if [[ "$CLEANLOGS" == true ]]; then
	echo "Cleaning log files";
	rm "${LOGSDIR%/}"/gdrive-backup-"$LOGSDATESTRING"*.log && echo "- Deleted ${LOGSDIR%/}/gdrive-backup-$LOGSDATESTRING*.log";
	rm "${LOGSDIR%/}"/gdrive-cleanup-"$LOGSDATESTRING"*.log && echo "- Deleted ${LOGSDIR%/}/gdrive-cleanup-$LOGSDATESTRING*.log";
fi;

echo "Archive cleanup is complete";