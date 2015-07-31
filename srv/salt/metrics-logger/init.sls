logger-metrics-script:
  file.managed:
    - name: /opt/metrics.sh
    - source: salt://metrics-logger/metrics.sh
    - src: 
    - user: root
    - group: root
    - mode: 700

logger-crontab-metrics:
  cron.present:
    - require:
      - file: logger-metrics-script
    - name: /bin/bash /opt/metrics.sh
    - identifier: metrics
    - user: root

logger-crontab-remove-cpu-metrics:
  cron.absent:
    - name: cpu-metrics

logger-crontab-remove-memory-metrics:
  cron.absent:
    - name: memory-metrics

logger-crontab-remove-disk-metrics:
  cron.absent:
    - name: disk-metrics