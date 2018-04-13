import os
import logging
import types
import functools
import salt.utils

from salt.utils import namespaced_function
import salt.modules.win_pkg
from salt.modules.win_pkg import *
from salt.ext.six.moves.urllib.parse import urlparse as _urlparse


PKG_DATA = {}


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
    if salt.utils.is_windows():
        return True
    return (False, 'This module only works on Windows.')


def refresh_db(*args, **kwargs):
    '''
    Override refresh db and peform a no-op
    '''
    return


def list_pkgs(*args, **kwargs):
    '''
    Override list packages beause we do not expect to have a win_repo cloned
    yet.
    '''
    return {}


def _get_package_info(name, **kwargs):
    '''
    Define package info via module level PKG_DATA attribute or via a pkg_data
    keyword argument passed to install.
    '''
    if 'orig_func' in kwargs:
        pkg_data = kwargs['orig_func'](name, kwargs)
        pkg_data.update(PKG_DATA)
    else:
        pkg_data = PKG_DATA
    if 'pkg_data' in kwargs:
        pkg_data.update(kwargs['pkg_data'])
    return pkg_data[name]


def install(*args, **kwargs):
    '''
    Winrepo install that can install packages without a win_repo, the package
    definition can passed to install via a pkg_data keyword argument.
    '''
    if 'pkg_data' in kwargs:

    _orig_get_package_info = salt.modules.win_pkg._get_package_info
    pkg_install = namespaced_function(salt.modules.win_pkg.install, globals())
    try:
        salt.modules.win_pkg.get_package_info = functools.partial(
            _get_package_info,
            pkg_data=kwargs.get('pkg_data', {}),
            orig_func=_orig_get_package_info,
        )
        return pkg_install(*args, **kwargs)
    finally:
        salt.modules.win_pkg._get_package_info = _orig_get_package_info
