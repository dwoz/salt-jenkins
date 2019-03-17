{%- set salt_dir = salt['config.get']('python_install_dir', 'c:\\salt').rstrip('\\') %}
{%- set scripts_dir = salt_dir.replace('\\', '\\\\') | path_join('bin', 'Scripts').replace('\\', '\\\\') %}

include:
  {%- if salt['config.get']('py3', False) %}
    - python3
  {%- else %}
    - python27
  {%- endif %}

update-env-vars:
  environ.setenv:
    - name: PATH
    - value: "{{ scripts_dir }};$env:Path"
    - permanent: true
    - order: 2
    - require:
    {%- if salt['config.get']('py3', False) %}
      - python3
    {%- else %}
      - python2
    {%- endif %}
