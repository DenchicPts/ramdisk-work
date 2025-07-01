#!/bin/bash
set -e

MOUNT_POINT="/mnt/ramdisk"
BACKUP_DIR="/mnt/ramdisk.backup"
ARCHIVE="$BACKUP_DIR/ramdisk_backup.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup RAM disk contents
echo "Saving contents of the RAM disk..."
rsync -a --delete "$MOUNT_POINT/" "$BACKUP_DIR/"
