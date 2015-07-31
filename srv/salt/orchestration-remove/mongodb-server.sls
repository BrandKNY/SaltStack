#It's tempting to put them in high state but that would be incompatible if they
#have orchestration rules
mongodb-server-update-maptycs:
  salt.state:
    - tgt: roles:maptycs
    - tgt_type: grain
    - sls:
      - maptycs
    - queue: True

mongodb-server-update-maptycs-worker:
  salt.state:
    - tgt: roles:maptycs-worker
    - tgt_type: grain
    - sls:
      - maptycs-worker
    - queue: True

mongodb-server-update-wheat:
  salt.state:
    - tgt: roles:wheat
    - tgt_type: grain
    - sls:
      - wheat
    - queue: True

mongodb-server-update-wheat-worker:
  salt.state:
    - tgt: roles:wheat-worker
    - tgt_type: grain
    - sls:
      - wheat-worker
    - queue: True