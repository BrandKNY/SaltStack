setup-install-pkgs:
  pkg.installed:
    - name: python26-pip

setup-install-pip-pkgs:
  pip.installed:
    - name: boto
    - require:
      - pkg: setup-install-pkgs
    - bin_env: /usr/bin/pip-2.6

setup-remove-hosts:
  file.absent:
    - name: /etc/hosts

setup-add-hostname:
  network.system:
    - enabled: True
    - hostname: {{ grains['id'] }}
  cmd.run:
    - name: hostname {{ grains['id'] }}
  file.managed:
    - require:
      - file: setup-remove-hosts
    - name: /etc/hosts
    - source: salt://setup/hosts
    - mode: 644
    - user: root
    - group: root
    - template: jinja

rsyslog:
  service.running:
    - enable: True
    - watch:
        - file: setup-add-hostname