kibana-kill-server-ps:
  cmd.run:
    - name: kill -9 $(ps -ef | grep "kibana" | awk '{print $2}') 2> /dev/null

kibana-start-server-ps:
  cmd.run:
    - require:
      - cmd: kibana-kill-server-ps
    - name: nohup /home/kibana/kibana_server/bin/kibana > /dev/null 2>&1 </dev/null &