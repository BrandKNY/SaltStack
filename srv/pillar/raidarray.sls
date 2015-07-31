raidarray:
  devices: ['/dev/xvdf','/dev/xvdg']
  mountpoint: /mnt/md127
  raiddevpath: /dev/md127
  raiddev: md127
  level: 0
  type: ext4
  directory: mongo
  usr: mongod
  grp: mongod