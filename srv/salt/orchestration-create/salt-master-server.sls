saltmaster-server-setup:
  salt.state:
    - tgt: {{ salt['pillar.get']('minion') }}
    - queue: True
    - sls:
      - setup

saltmaster-server-state:
  salt.state:
    - require:
      - salt: saltmaster-server-setup
    - tgt: {{ salt['pillar.get']('minion')  }}
    - queue: True
    - highstate: True