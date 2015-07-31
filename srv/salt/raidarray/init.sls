raid-create-array:
  cmd.script:
    - source: salt://raidarray/create_raid.sh
    - cwd: /
    - user: root

mongodb-installed:
  pkg.installed:
    - require:
      - cmd: raid-create-array
    - name: mongodb
    - sources:
      - mongodb-org-server: salt://mongodb/mongodb-org-server-3.0.3-1.amzn1.x86_64.rpm
      - mongodb-org-shell: salt://mongodb/mongodb-org-shell-3.0.3-1.amzn1.x86_64.rpm

raid-mount:
  mount.mounted:
    - require:
      - pkg: mongodb-installed
    - name: /mnt/md127
    - device: /dev/md127
    - fstype: ext4
    - dump: 0
    - pass_num: 2
    - persist: True
    - mkmnt: True
    - opts: defaults,nofail
    - user: root

raid-mongo-datastore:
  file.directory:
    - require:
      - mount: raid-mount
    - name: /mnt/md127/mongo
    - user:  {{ pillar['raidarray']['usr'] }}
    - group: {{ pillar['raidarray']['grp'] }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

raid-limits-conf:
  file.managed:
    - require:
      - file: raid-mongo-datastore
    - name: /etc/security/limits.conf
    - source: salt://raidarray/limits.conf
    - mode: 644
    - user: root
    - group: root

raid-limits-nproc:
  file.managed:
    - require:
      - file: raid-limits-conf
    - name: /etc/security/limits.d/90-nproc.conf
    - source: salt://raidarray/90-nproc.conf
    - mode: 644
    - user: root
    - group: root


raid-udev-ebs:
  file.managed:
    - require:
      - file: raid-limits-nproc
    - name: /etc/udev/rules.d/85-ebs.rules
    - source: salt://raidarray/85-ebs.rules
    - mode: 644
    - user: root
    - group: root
    - template: jinja