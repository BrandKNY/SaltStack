base:
  'roles:logger':
    - match: grain
    - logger
    - metrics-logger
  'roles:elasticsearch':
    - match: grain
    - elasticsearch
  'roles:logstash':
    - match: grain
    - logstash
    - metrics-logger
  'roles:riemann':
    - match: grain
    - riemann
  'roles:mongodb':
    - match: grain
    - mongodb
  'roles:myapp':
    - match: grain
    - maptycs
  'roles:myapp-worker':
    - match: grain
    - maptycs-worker
  'roles:wheat':
    - match: grain
    - wheat
  'roles:wheat-worker':
    - match: grain
    - wheat-worker
  'roles:edgeserver':
    - match: grain
    - nginx
  'roles:kibana':
    - match: grain
    - kibana
  'roles:saltmaster':
    - match: grain
    - salt-masters