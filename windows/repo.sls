#j{%- set salt_dir = salt['config.get']('salt_dir', 'c:\\salt').rstrip('\\') %}
#j{%- set bin_env = salt_dir + '\\bin' %}
#j{%- set pip_bin = bin_env + '\\Scripts\\pip.exe' %}
#j{%- set cwd_dir = bin_env + '\\Scripts' %}
#j{%- set git_binary = 'git' | which %}
#j{%- if not git_binary  %}
#jinclude:
#j  - python.urllib3
#j  - python.dulwich
#j
#jextend:
#j  urllib3:
#j    pip.installed:
#j      - use_wheel: true
#j      {#- We explicitly pass bin_env because we want these requirements install for salt itself to work #}
#j      - bin_env: {{ bin_env }}
#j      - cwd: {{ cwd_dir }}
#j  dulwich:
#j    pip.installed:
#j      {#- We explicitly pass bin_env because we want these requirements install for salt itself to work #}
#j      - bin_env: {{ bin_env }}
#j      - cwd: {{ cwd_dir }}
#j      - global_options: '--pure'
#j      - require:
#j        - urllib3
#j      - reload_modules: True
#j{%- endif %}
#j
#jdownload-git-repos:
#j  module.run:
#j    {%- if git_binary %}
#j    - name: winrepo.update_git_repos
#j    {%- else %}
#j    - name: winrepo_bootstrap.download_git_repos
#j    - require:
#j      - dulwich
#j    {%- endif %}
#j    - order: 2
#j
#jwin-pkg-refresh:
#j  module.run:
#j    - name: pkg.refresh_db
#j    - verbose: true
#j    - failhard: true
#j    - require:
#j      - download-git-repos
#j    - order: 2
