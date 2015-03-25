#!/bin/bash
# Backs up file to object storage via sftp

export LOGNAME="<logon name>"
export FTP_PASSWORD="<api key>"
export TARGET_URL="sftp://lon02.objectstorage.service.networklayer.com/<container>/<directory>"
export OPTIONS="--full-if-older-than 1M --encrypt-key <gpg key id>"
export SOURCE_DIRS="--include <dir 1> --include <dir n>" 

# Check what needs to be done if nothing defined then just backup
case $1 in
	status)
		echo "Showing backup status..."
		duplicity collection-status $TARGET_URL $OPTIONS
		;;
	restore)
		echo "Restoring files..."
		duplicity $TARGET_URL $2 $OPTIONS
		;;
		
	backup)
		echo "Backing up..."
		duplicity $SOURCE_DIRS --exclude '**' / $TARGET_URL $OPTIONS
		;;
	*)
		echo "Usage $0 <status |restore <restoredir> | backup | shell>."
		;;
esac
