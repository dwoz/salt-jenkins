{%- if grains['os'] != 'Windows' %}
include:
  - python.pip
{%- endif %}

kubernetes:
  {%- if grains['os'] == 'CentOS' and grains['osmajorrelease']|int >= 7 %}
  pkg.installed:
    - name: python2-kubernetes
  {%- else %}
  pip.installed:
    - name: kubernetes < 4.0
    - bin_env: {{ salt['config.get']('virtualenv_path', '') }}
    - cwd: {{ salt['config.get']('pip_cwd', '') }}
    {%- if grains['os'] != 'Windows' %}
    - require:
      - cmd: pip-install
    {%- endif %}
  {%- endif %}
