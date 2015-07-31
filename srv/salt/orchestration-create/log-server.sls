#Update the mine
log-server-mine:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['minion'] }}

#Initialize the log server
log-server-setup:
  salt.state:
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - sls:
      - setup

#Put the logserver in its high state
log-server-state:
  salt.state:
    - require:
      - salt: log-server-setup 
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - highstate: True

#Update the elasticsearch state for all elasticsearch server
log-server-update-elasticsearch:
  salt.state:
    - require:
      - salt: log-server-state
    - tgt: roles:elasticsearch
    - tgt_type: grain
    - queue: True
    - sls:
      - elasticsearch

#Update the logger state for all the loggers
log-server-update-logger:
  salt.state:
    - require:
      - salt: log-server-state
    - tgt: 'roles:logger'
    - tgt_type: grain
    - queue: True
    - sls:
      - logger

#Update state for all the kibana servers to start/restart prcess since elastic search can be assumed to be alive
log-server-update-kibana:
  salt.state:
    - require:
      - salt: log-server-state
    - tgt: 'roles:kibana'
    - tgt_type: grain
    - queue: True
    - sls:
      - kibana