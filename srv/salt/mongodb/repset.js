rs.initiate({
    _id : "{{ pillar['mongodb']['replicaset'] }}",
    members : [
    	{% set i = 0 %}
    	{% for server, addrs in salt.mine.get('roles:mongodb', 'private_ip', expr_form='grain').items() %}
			{ _id : {{ i }}, host : "{{addrs}}"},
			{% set i = i+1 %}
    	{% endfor %}
    ]
});