import os
import logging
import types
import salt.utils
from salt.exceptions import CommandExecutionError

from salt.utils import namespaced_function
import salt.modules.win_pkg
from salt.modules.win_pkg import *
from salt.ext.six.moves.urllib.parse import urlparse as _urlparse

PKG_DATA = {
    'git': {
        '2.16.2': {
        'full_name': 'Git version 2.16.2',
        'installer': 'https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/Git-2.16.2-64-bit.exe',
        'install_flags': '/VERYSILENT /NORESTART /SP- /NOCANCEL',
        'uninstaller': '{{ PROGRAM_FILES }}\Git\unins000.exe',
        'uninstall_flags': '/VERYSILENT /NORESTART & {{ PROGRAM_FILES }}\Git\unins001.exe /VERYSILENT /NORESTART & exit 0',
        'msiexec': False,
        'locale': 'en_US',
        'reboot': False,
        }
     }
}
for name in dir(salt.modules.win_pkg):
    attr = getattr(salt.modules.win_pkg, name)
    if isinstance(attr, types.FunctionType):
        if attr == 'install':
            continue
        if attr == 'refresh_db':
            continue
        if attr == 'list_pkgs':
            continue
        if attr in globals():
            continue
        globals()[name] = salt.utils.namespaced_function(attr, globals())

def __virtual__():
    return True

def refresh_db(*args, **kwargs):
    return

def list_pkgs(*args, **kwargs):
    return {}

def _get_package_info(name, *args, **kwargs):
    return PKG_DATA[name]


def install(*args, **kwargs):
    _orig_get_package_info = salt.modules.win_pkg._get_package_info
    pkg_install = namespaced_function(salt.modules.win_pkg.install, globals())
    try:
        salt.modules.win_pkg.get_package_info = _get_package_info
        return pkg_install(*args, **kwargs)
    finally:
        salt.modules.win_pkg._get_package_info = _orig_get_package_info
