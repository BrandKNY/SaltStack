elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://elasticsearch/elasticsearch-1.5.2.noarch.rpm
  service.running:
    - enable: True
    - require: 
      - pkg: elasticsearch
      - cmd: elasticsearch-s3-plugin
    - watch:
      - file: elasticsearch-config-file

elasticsearch-s3-plugin:
  cmd.wait:
    - watch:
      - pkg: elasticsearch
    - name: ./bin/plugin install elasticsearch/elasticsearch-cloud-aws
    - user: root
    - cwd: /usr/share/elasticsearch/

elasticsearch-config-file:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elasticsearch/elasticsearch.yml
    - mode: 600
    - user: elasticsearch
    - group: elasticsearch
    - template: jinja

elasticsearch-dns-record:
  route53.present:
    - require:
      - service: elasticsearch
    - name: {{ pillar['elasticsearch']['hostname'] }}.
    - value: "{{ salt.mine.get('roles:elasticsearch', 'private_ip', expr_form='grain').items() | join(",", attribute=1) }}"
    - zone: staging-internal.
    - ttl: 300
    - record_type: A
    - keyid: {{ pillar['aws']['key'] }}
    - key: {{ pillar['aws']['secretKey'] }}
