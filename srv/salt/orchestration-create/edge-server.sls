#TODO: Update the load balancer

#Update the mine
edge-server-mine:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['minion'] }}

#Initialize the edge server
edge-server-setup:
  salt.state:
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - sls:
      - setup

#Put the edge server in its high state
edge-server-state:
  salt.state:
    - require:
      - salt: edge-server-setup 
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - highstate: True