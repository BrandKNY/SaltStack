{% if data['name'].startswith("log-server") %}
remove-log-server:
  runner.state.orchestrate:
    - mods: orchestration-remove.log-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if data['name'].startswith("riemann-server") %}
remove-riemann-server:
  runner.state.orchestrate:
    - mods: orchestration-remove.riemann-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if data['name'].startswith("mongodb-server") %}
remove-mongodb-server:
  runner.state.orchestrate:
    - mods: orchestration-remove.mongodb-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if data['name'].startswith("myapp-server") %}
remove-myapp-server:
  runner.state.orchestrate:
    - mods: orchestration-remove.myapp-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if data['name'].startswith("wheat-server") %}
remove-wheat-server:
  runner.state.orchestrate:
    - mods: orchestration-remove.wheat-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}

{% if data['name'].startswith("edge-server") %}
remove-edge-server:
  runner.state.orchestrate:
    - mods: orchestration-remove.edge-server
    - pillar:
        minion: {{ data['name'] }}

{% endif %}