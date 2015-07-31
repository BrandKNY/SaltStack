#Update the elasticsearch state for all elasticsearch server
log-server-update-elasticsearch:
  salt.state:
    - tgt: roles:elasticsearch
    - tgt_type: grain
    - sls:
      - elasticsearch
    - queue: True

#Update the logger state for all the loggers
log-server-update-logger:
  salt.state:
    - tgt: 'roles:logger'
    - tgt_type: grain
    - sls:
      - logger
    - queue: True