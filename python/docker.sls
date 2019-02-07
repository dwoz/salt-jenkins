{%- if grains['os'] != 'Windows' %}
include:
  - python.pip
{%- endif %}

{%- if grains['os'] == 'Windows' %}
  {%- set docker = 'docker==2.7.0' %}
{%- else %}
  {%- set docker = 'docker' %}
{%- endif %}

# Can't use "docker" as ID declaration, it's being used in salt://docker.sls
docker_py:
  {%- if grains['os'] == 'CentOS' and grains['osmajorrelease']|int >= 7 %}
  pkg.installed:
    - name: python-docker-py
  {%- else %}
  pip.installed:
    - name: {{docker}}
    - bin_env: {{ salt.config.get('virtualenv_path', '') }}
    - cwd: {{ salt['config.get']('pip_cwd', '') }}
    {%- if grains['os'] != 'Windows' %}
    - require:
      - cmd: pip-install
    {%- endif %}
  {%- endif %}
