#!/bin/bash
set -e

MOUNT_POINT="/mnt/ramdisk"
BACKUP_DIR="/mnt/ramdisk.backup"
ARCHIVE="$BACKUP_DIR/ramdisk_backup.tar.gz"

# Create directories
mkdir -p "$MOUNT_POINT"
mkdir -p "$BACKUP_DIR"

# Mount tmpfs with 8GB size
mountpoint -q "$MOUNT_POINT" || mount -t tmpfs -o size=8G tmpfs "$MOUNT_POINT"

# Restore from backup if it exists
if [ "$(ls -A "$BACKUP_DIR")" ]; then
    echo "Restoring RAM disk from backup folder..."
    rsync -a "$BACKUP_DIR/" "$MOUNT_POINT/"
else
    echo "Backup is empty or does not exist. Nothing to restore."
fi