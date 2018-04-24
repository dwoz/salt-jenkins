# just 32-bit x86 installer available
{% if grains['cpuarch'] == 'AMD64' %}
    {% set PROGRAM_FILES = "%ProgramFiles(x86)%" %}
{% else %}
    {% set PROGRAM_FILES = "%ProgramFiles%" %}
{% endif %}
gvim:
  module.run:
    - name: winrepo_pkg.install
    - args:
      - gvim
    - kwargs:
        win_repo:
          gvim:
            2.16.2:
              full_name:  'Vim 8.0.3'
              installer: 'http://netcologne.dl.sourceforge.net/project/cream/Vim/8.0.3/gvim-8-0-3.exe'
              install_flags: '/S'
              uninstaller: '{{ PROGRAM_FILES }}\Vim\vim80\uninstall.exe'
              uninstall_flags: '/S'
              msiexec: False
              locale: en_US
              reboot: False

gvim_scripts:
  cmd.run:
    - name: |-
        REG ADD HKEY_CLASSES_ROOT\*\shell\vim /ve /f /d "Edit with Vim"
        IF /i "%Processor_Architecture%"=="x86" REG ADD HKEY_CLASSES_ROOT\*\shell\vim\command /ve /f /d "'C:\\Program Files\\Vim\\vim73\\gvim.exe' %%1"
        IF /i "%Processor_Architecture%"=="AMD64" REG ADD HKEY_CLASSES_ROOT\*\shell\vim\command /ve /f /d "'C:\\Program Files (x86)\\Vim\\vim73\\gvim.exe' %%1"
    - shell: powershell
