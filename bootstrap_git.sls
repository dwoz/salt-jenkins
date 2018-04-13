bootstrap_git:
  module.run:
    - name: bootstrap_git.install
    - args:
      - git
    - kwargs:
        win_repo:
          git:
            2.16.2:
              full_name: Git version 2.16.2
              installer: https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/Git-2.16.2-64-bit.exe
              install_flags: /VERYSILENT /NORESTART /SP- /NOCANCEL
              uninstaller: https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/Git-2.16.2-64-bit.exe
              uninstall_flags: /VERYSILENT /NORESTART
              msiexec: False
              locale: en_US
              reboot: False
