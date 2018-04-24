gvim:
  module.run:
    - name: winrepo_pkg.install
    - args:
      - gvim
    - kwargs:
        win_repo:
          full_name:  'Vim 8.0.3'
          installer: 'http://netcologne.dl.sourceforge.net/project/cream/Vim/8.0.3/gvim-8-0-3.exe'
          install_flags: '/S'
          uninstaller: '{{ PROGRAM_FILES }}\Vim\vim80\uninstall.exe'
          uninstall_flags: '/S'
          msiexec: False
          locale: en_US
          reboot: False
