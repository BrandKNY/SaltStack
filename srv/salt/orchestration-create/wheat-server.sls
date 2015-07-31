#Update the mine
wheat-server-mine:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['minion'] }}

#Initialize the wheat server
wheat-server-setup:
  salt.state:
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - sls:
      - setup

#Put the wheat server in its high state
wheat-server-state:
  salt.state:
    - require:
      - salt: wheat-server-setup 
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - highstate: True


#Update edgeservers
wheat-server-update-nginx:
  salt.state:
    - require:
      - salt: wheat-server-state
    - tgt: roles:edgeserver
    - tgt_type: grain
    - queue: True
    - sls:
      - nginx