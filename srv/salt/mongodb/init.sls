mongodb-install-pkgs:
  pkg.installed:
    - sources:
      - mongodb-org-server: salt://mongodb/mongodb-org-server-3.0.3-1.amzn1.x86_64.rpm
      - mongodb-org-shell: salt://mongodb/mongodb-org-shell-3.0.3-1.amzn1.x86_64.rpm
      - mongodb-org-tools: salt://mongodb/mongodb-org-tools-3.0.3-1.amzn1.x86_64.rpm

mongodb-config-file:
  file.managed:
    - name: /etc/mongod.conf
    - source: salt://mongodb/mongodb.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja

mongodb-service:
  service.running:
    - name: mongod
    - require: 
      - pkg: mongodb-install-pkgs
    - watch:
      - file: mongodb-config-file
    - enable: True

mongodb-ready:
  cmd.run:
    - name: sleep 5
    - require:
      - service: mongodb-service

mongodb-replica-set-config-file:
  file.managed:
    - name: /usr/libexec/mongo/repset_init.js
    - source: salt://mongodb/repset.js
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja

mongodb-replica-set-config:
  cmd.run:
    - name: mongo /usr/libexec/mongo/repset_init.js
    - require:
      - cmd: mongodb-ready
    - watch:
      - file: mongodb-replica-set-config-file
    - user: root
    - group: root

mongodb-dns-record:
  route53.present:
    - require:
      - cmd: mongodb-replica-set-config
    - name: {{ pillar['mongodb']['hostname'] }}.
    - value: "{{ salt.mine.get('roles:mongodb', 'private_ip', expr_form='grain').items() | join(",", attribute=1) }}"
    - zone: staging-internal.
    - ttl: 300
    - record_type: A
    - keyid: {{ pillar['aws']['key'] }}
    - key: {{ pillar['aws']['secretKey'] }}