#!/bin/bash
mdadm --create --verbose /dev/md127 --level=stripe --raid-devices=2 /dev/xvdf /dev/xvdg 2>/dev/null
mkfs.ext4 /dev/md127
mkdir -p /mnt/md127
exit 0