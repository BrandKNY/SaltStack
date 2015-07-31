kibana-acl:
  group.present:
    - name: {{ pillar['kibana']['acl_name'] }}
  user.present:
    - name: {{ pillar['kibana']['acl_name'] }}
    - gid_from_name: true
    - home: /home/{{ pillar['kibana']['acl_name'] }}/

kibana-install-package:
  archive.extracted:
    - name: /opt/
    - source: https://download.elastic.co/kibana/kibana/{{ pillar['kibana']['package_version'] }}.tar.gz
    - source_hash: {{ pillar['kibana']['checksum'] }}
    - tar_options: z
    - archive_format: tar
    - if_missing: /opt/{{ pillar['kibana']['package_version'] }}/bin/kibana
    - archive_user: {{ pillar['kibana']['acl_name'] }}
    - keep: True

kibana-manage-config:
  file.managed:
    - require:
      - archive: kibana-install-package
    - name: /opt/{{ pillar['kibana']['package_version'] }}/config/kibana.yml
    - source: salt://kibana/kibana.yml
    - replace: True
    - user: {{ pillar['kibana']['acl_name'] }}
    - group: {{ pillar['kibana']['acl_name'] }}
    - mode: 664
    - template: jinja

{% if salt.mine.get('roles:logstash', 'private_ip', expr_form='grain').items() | length > 0 %}

kibana-start-server-ps:
  cmd.run:
    - name: nohup /opt/{{ pillar['kibana']['package_version'] }}/bin/kibana > /dev/null 2>&1 </dev/null &
    - user: kibana
    - cwd: /home/kibana
    - unless: test $(ps -ef | grep "[k]ibana" | awk '{print $2}')

{% endif %}

{% if salt.mine.get('roles:kibana', 'private_ip', expr_form='grain').items() | length > 0 %}

kibana-start-server-ps:
  cmd.run:
    - name: nohup /opt/{{ pillar['kibana']['package_version'] }}/bin/kibana > /dev/null 2>&1 </dev/null &
    - user: kibana
    - cwd: /home/kibana
    - unless: test $(ps -ef | grep "[k]ibana" | awk '{print $2}')

{% endif %}