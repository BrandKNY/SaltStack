logstash:
  pkg.installed:
    - sources:
      - logstash: salt://logstash/logstash-1.5.0-1.noarch.rpm

logstash-riemann-plugin:
  cmd.wait:
    - watch:
      - pkg: logstash
    - name: ./bin/plugin install logstash-output-riemann
    - user: logstash
    - cwd: /opt/logstash/


/etc/logstash/conf.d/logstash.conf:
  file.managed:
    - source: salt://logstash/logstash.conf
    - mode: 600
    - user: logstash
    - group: logstash
    - template: jinja

logstash-service:
  service.running:
    - require: 
      - cmd: logstash-riemann-plugin
      - pkg: logstash
    - watch:
      - file: /etc/logstash/conf.d/logstash.conf
    - name: logstash
    - enable: True

/etc/rsyslog.d/logstash.conf:
  file.managed:
    - source: salt://logstash/rsyslog.conf
    - mode: 600
    - user: root
    - group: root
    - template: jinja

logstash-rsyslog-spool:
  file.directory:
    - name: /var/spool/rsyslog
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

rsyslog:
  service.running:
    - enable: True
    - watch:
        - file: /etc/rsyslog.d/logstash.conf

log-server-dns-record:
  route53.present:
    - require:
      - service: rsyslog
    - name: {{ pillar['logserver']['hostname'] }}.
    - value: "{{ salt.mine.get('roles:logstash', 'private_ip', expr_form='grain').items() | join(",", attribute=1) }}"
    - zone: staging-internal.
    - ttl: 300
    - record_type: A
    - region: us-east-1
    - keyid: {{ pillar['aws']['key'] }}
    - key: {{ pillar['aws']['secretKey'] }}