nginx:
  pkg.installed:
    - sources:
      - nginx: salt://nginx/nginx-1.8.0-1.el5.ngx.x86_64.rpm
  service.running:
    - require:
      - pkg: nginx
    - watch:
      - file: /etc/nginx/conf.d/myapp.conf
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/ssl/app.myapp.key
      - file: /etc/nginx/ssl/myapp_combined.crt
    - enable: True

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja

/etc/nginx/conf.d/myapp.conf:
  file.managed:
    - source: salt://nginx/myapp.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja

/etc/nginx/ssl/myapp_combined.crt:
  file.managed:
    - source: salt://nginx/myapp_combined.crt
    - mode: 640
    - user: root
    - group: root
    - makedirs: True

/etc/nginx/ssl/app.myapp.key:
  file.managed:
    - source: salt://nginx/app.myapp.key
    - mode: 640
    - user: root
    - group: root
    - makedirs: True

nginx-public-dns-record:
  route53.present:
    - require:
      - service: nginx
    - name: {{ pillar['myapp']['domain'] }}.
    - value: "{{ salt.mine.get('roles:edgeserver', 'public_ip', expr_form='grain').items() | join(",", attribute=1) }}"
    - zone: myapp.com.
    - ttl: 60
    - record_type: A
    - keyid: {{ pillar['aws']['key'] }}
    - key: {{ pillar['aws']['secretKey'] }}

nginx-private-dns-record:
  route53.present:
    - require:
      - service: nginx
    - name: {{ pillar['nginx']['hostname'] }}.
    - value: "{{ salt.mine.get('roles:edgeserver', 'private_ip', expr_form='grain').items() | join(",", attribute=1) }}"
    - zone: staging-internal.
    - ttl: 300
    - record_type: A
    - keyid: {{ pillar['aws']['key'] }}
    - key: {{ pillar['aws']['secretKey'] }}

