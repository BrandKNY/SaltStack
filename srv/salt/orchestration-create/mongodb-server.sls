#Update the mine
mongodb-server-mine:
  salt.function:
    - name: mine.update
    - tgt: {{ pillar['minion'] }}

#Initialize the mongodb server
#Setup the Raid Drives and System Configuration for MongoDB
mongodb-server-setup:
  salt.state:
    - tgt: {{ pillar['minion'] }}
    - sls:
      - setup
      - raidarray

#Put the mongodb server in its high state
mongodb-server-state:
  salt.state:
    - require:
      - salt: mongodb-server-setup 
    - tgt: {{ pillar['minion'] }}
    - queue: True
    - highstate: True


#Update all the roles that depend on a mongodb database
mongodb-server-update-maptycs:
  salt.state:
    - require:
      - salt: mongodb-server-state
    - tgt: roles:maptycs
    - tgt_type: grain
    - queue: True
    - sls:
      - maptycs

mongodb-server-update-maptycs-worker:
  salt.state:
    - require:
      - salt: mongodb-server-state
    - tgt: roles:maptycs-worker
    - tgt_type: grain
    - queue: True
    - sls:
      - maptycs-worker

mongodb-server-update-wheat:
  salt.state:
    - require:
      - salt: mongodb-server-state
    - tgt: roles:wheat
    - tgt_type: grain
    - queue: True
    - sls:
      - wheat

mongodb-server-update-wheat-worker:
  salt.state:
    - require:
      - salt: mongodb-server-state
    - tgt: roles:wheat-worker
    - tgt_type: grain
    - queue: True
    - sls:
      - wheat-worker