/etc/rsyslog.d/logger.conf:
  file.managed:
    - source: salt://logger/rsyslog.conf
    - mode: 600
    - user: root
    - group: root
    - template: jinja

logger-rsyslog-spool:
  file.directory:
    - name: /var/spool/rsyslog
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

logger-rsyslog:
  service.running:
    - watch:
        - file: /etc/rsyslog.d/logger.conf
    - name: rsyslog
    - enable: True
