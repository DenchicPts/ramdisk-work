**RAMDISK-WORK** is a script-based system for automatic creation, initialization, and backup of a RAM disk on Linux.  
It is suitable for tasks requiring high-speed I/O and temporary data storage.

---

## 📁 Project Structure

```
RAMDISK-WORK/
├── home_user_.config_systemd_user/
│   ├── ramdisk-backup.service       # systemd unit for backup
│   ├── ramdisk-init.service         # systemd unit for RAM disk initialization
│   └── Readme.txt                   # short description (may be outdated)
│
├── usr_local_bin/
│   ├── ramdisk-backup.sh            # backup script for the RAM disk
│   └── ramdisk-init.sh              # initialization script for the RAM disk
│
└── README.md                        # this description file
```

---

## ⚙️ Installation

1. **Copy scripts to the system directory:**

```bash
sudo cp usr_local_bin/ramdisk-*.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/ramdisk-*.sh
```

2. **Create symbolic links for systemd:**

```bash
# Replace {user} with your username
sudo ln -s /home/{user}/.config/systemd/user/ramdisk-backup.service /etc/systemd/system/ramdisk-backup.service
```

3. **Reload systemd and enable the services:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable ramdisk-init.service
sudo systemctl enable ramdisk-backup.service
sudo systemctl start ramdisk-init.service
```

---

## 🧠 Component Description

- **`ramdisk-init.sh`**  
  Creates the RAM disk, mounts it in the target directory, and restores backup files (if any).

- **`ramdisk-backup.sh`**  
  This script creates a backup of the RAM disk contents using `rsync`. You can change the backup method to anything else (e.g., tar, zip, custom archiver) depending on your needs.

  **Note:**  
  - By default, this backup is not compressed and is stored in an open-access directory.
  - The use of `rsync` provides efficient synchronization but does not apply compression or encryption.


```bash
#!/bin/bash
set -e

MOUNT_POINT="/mnt/ramdisk"
BACKUP_DIR="/mnt/ramdisk.backup"
ARCHIVE="$BACKUP_DIR/ramdisk_backup.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup RAM disk contents using rsync
echo "Saving contents of the RAM disk..."
rsync -a --delete "$MOUNT_POINT/" "$BACKUP_DIR/"
```

- **systemd units**
  - `ramdisk-init.service` — automatically initializes the RAM disk on boot.
  - `ramdisk-backup.service` — automatically saves RAM disk contents before shutdown.

---

## 🧱 Manual Example

If you want to manually mount a RAM disk:

```bash
sudo mount -t tmpfs -o size=512M tmpfs /mnt/ramdisk
```

These scripts automate the process above.

---

## ❗ Notes

- The RAM disk exists only in system memory.
- All contents will be lost after a reboot unless backed up.
- Make sure all paths and permissions in the scripts are correctly set up.