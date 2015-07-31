#Update edgeservers
wheat-server-update-nginx:
  salt.state:
    - tgt: roles:edgeserver
    - tgt_type: grain
    - sls:
      - nginx
    - queue: True