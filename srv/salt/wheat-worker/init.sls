wheat-worker-install-pkgs:
  pkg.installed:
    - enablerepo: epel
    - pkgs:
      - java-1.7.0-openjdk
      - python-psutil

wheat-worker-acl:
  group.present:
    - name: wheat-worker
  user.present:
    - name: wheat-worker
    - gid_from_name: true
    - home: /home/wheat-worker/

wheat-worker-jar:
  file.managed:
    - require:
      - user: wheat-worker-acl
      - group: wheat-worker-acl
    - source: salt://wheat-worker/wheat-worker.jar
    - name: /home/wheat-worker/wheat-worker.jar
    - user: wheat-worker
    - group: wheat-worker
    - mode: 600

wheat-worker-aspectj-jar:
  file.managed:
    - require:
      - user: wheat-worker-acl
      - group: wheat-worker-acl
    - source: salt://wheat-worker/aspectjweaver.jar
    - name: /home/wheat-worker/aspectjweaver.jar
    - user: wheat-worker
    - group: wheat-worker
    - mode: 600

wheat-worker-config:
  file.managed:
    - require:
      - user: wheat-worker-acl
      - group: wheat-worker-acl
    - name: /home/wheat-worker/application.yml
    - source: salt://wheat-worker/config.yml
    - user: wheat-worker
    - group: wheat-worker
    - mode: 600
    - template: jinja

wheat-worker-stop:
  process.absent:
    - watch: 
      - file: wheat-worker-jar
      - file: wheat-worker-aspectj-jar
      - file: wheat-worker-config
    - user: wheat-worker
    - name: wheat-worker

{% if salt['mine.get']('roles:mongodb', 'network.ip_addrs', expr_form='grain').items()|length > 0 %}

wheat-worker-start:
  cmd.run:
    - require: 
      - process: wheat-worker-stop
    - user: wheat-worker
    - name: "nohup java -javaagent:/home/wheat-worker/aspectjweaver.jar -jar /home/wheat-worker/wheat-worker.jar > /dev/null 2>&1 &"

{% endif %}