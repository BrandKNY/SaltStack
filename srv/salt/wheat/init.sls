wheat-install-pkgs:
  pkg.installed:
    - enablerepo: epel
    - pkgs:
      - java-1.7.0-openjdk
      - python-psutil

wheat-acl:
  group.present:
    - name: wheat
  user.present:
    - name: wheat
    - gid_from_name: true
    - home: /home/wheat/

wheat-jar:
  file.managed:
    - require:
      - user: wheat-acl
      - group: wheat-acl
    - source: salt://wheat/wheat.jar
    - name: /home/wheat/wheat.jar
    - user: wheat
    - group: wheat
    - mode: 600

wheat-config:
  file.managed:
    - require:
      - user: wheat-acl
      - group: wheat-acl
    - name: /home/wheat/application.yml
    - source: salt://wheat/config.yml
    - user: wheat
    - group: wheat
    - mode: 600
    - template: jinja

wheat-stop:
  process.absent:
    - watch: 
      - file: wheat-jar
      - file: wheat-config
    - user: wheat
    - name: wheat

{% if salt['mine.get']('roles:mongodb', 'private_ip', expr_form='grain').items()|length > 0 %}

wheat-start:
  cmd.run:
    - require: 
      - process: wheat-stop
    - user: wheat
    - name: "nohup java -jar /home/wheat/wheat.jar > /dev/null 2>&1 &"

{% endif %}