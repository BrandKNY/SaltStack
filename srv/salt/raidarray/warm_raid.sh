#!/bin/bash
if [ ! -d /mnt/md127/mongo ]; then
  dd if=/dev/zero of=/dev/xvdf bs=1M status=none 2>/dev/null
  dd if=/dev/zero of=/dev/xvdg bs=1M status=none 2>/dev/null
fi
exit 0