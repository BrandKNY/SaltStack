{% if 'name' in data and data['name'].startswith("log-server") %}
create-log-server:
  runner.state.orchestrate:
    - mods: orchestration-create.log-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'name' in data and data['name'].startswith("riemann-server") %}
create-riemann-server:
  runner.state.orchestrate:
    - mods: orchestration-create.riemann-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'name' in data and data['name'].startswith("mongodb-server") %}
create-mongodb-server:
  runner.state.orchestrate:
    - mods: orchestration-create.mongodb-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'name' in data and data['name'].startswith("myapp-server") %}
create-maptycs-server:
  runner.state.orchestrate:
    - mods: orchestration-create.myapp-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'name' in data and data['name'].startswith("wheat-server") %}
create-wheat-server:
  runner.state.orchestrate:
    - mods: orchestration-create.wheat-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'name' in data and data['name'].startswith("wheat-myapp-server") %}
create-wheat-server:
  runner.state.orchestrate:
    - mods: orchestration-create.wheat-server
    - pillar:
        minion: {{ data['name'] }}
create-maptycs-server:
  runner.state.orchestrate:
    - mods: orchestration-create.maptycs-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'name' in data and data['name'].startswith("edge-server") %}
create-edge-server:
  runner.state.orchestrate:
    - mods: orchestration-create.edge-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if 'data' in data and 'name' in data['data'] and data['data']['name'].startswith("salt-master-server") %}
create-salt-master-server:
  runner.state.orchestrate:
    - mods: orchestration-create.salt-master-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}