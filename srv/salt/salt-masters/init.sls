saltmaster-private-dns-record:
  route53.present:
    - name: {{ pillar['saltmaster']['hostname'] }}.
    - value: "{{ salt.mine.get('roles:saltmaster', 'private_ip', expr_form='grain').items() | join(",", attribute=1) }}"
    - zone: staging-internal.
    - ttl: 300
    - record_type: A
    - keyid: {{ pillar['aws']['key'] }}
    - key: {{ pillar['aws']['secretKey'] }}