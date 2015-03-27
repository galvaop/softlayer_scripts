#!/bin/bash

export HOME="/root"
export LOGNAME=""
export FTP_PASSWORD=""
export TARGET_URL=""
export OPTIONS="--full-if-older-than 3M --encrypt-key <keyid> --progress"
export SOURCE_DIRS="--include xxx --include yyy" 

# Check what needs to be done if nothing defined then inform
case $1 in
	status)
		echo "Showing backup status..."
		time duplicity collection-status $TARGET_URL $OPTIONS
		;;
	restore)
		echo "Restoring files..."
		time duplicity $TARGET_URL $2 $OPTIONS
		;;
	list)
		echo "Listing files..."
		time duplicity list-current-files $TARGET_URL $OPTIONS
		;;		
	backup)
		echo "Backing up..."
		time duplicity $SOURCE_DIRS --exclude '**' / $TARGET_URL $OPTIONS
		;;
	*)
		echo "Usage $0 <status |restore <restoredir> | backup | list>."
		;;
esac
