# -*- coding: utf-8 -*-
'''
    pip3_state
    ~~~~~~~~~~

    Custom PIP state module which wraps the existing pip module to set/use some
    default settings/parameters. Python 3 specific.
'''

# Import python libs
from __future__ import absolute_import
import types
import logging

# Import salt libs
from salt.utils.functools import namespaced_function
import salt.states.pip_state
from salt.states.pip_state import *  # pylint: disable=wildcard-import,unused-wildcard-import
from salt.states.pip_state import installed as pip_state_installed

__virtualname__ = 'pip3'

log = logging.getLogger()
_skip_funcs = (
    '_check_if_installed',
    '_check_version_format',
)
def _namespace_module(module, skip_funcs=_skip_funcs):
    for name in dir(module):
        if name in skip_fucs:
            continue
        attr = getattr(salt.states.pip_state, name)
        log.error("Namespace pip func %s", name)
        if isinstance(attr, types.FunctionType):
            if attr in ('installed',):
                continue
            if attr in globals():
                continue
            globals()[name] = namespaced_function(attr, globals())

# Let's namespace the pip_state_installed function
pip_state_installed = namespaced_function(pip_state_installed, globals())  # pylint: disable=invalid-name
_namespace_module(salt.states.pip_state)

def __virtual__():
    if 'pip.list' in __salt__:
        return __virtualname__
    return False


def installed(name, **kwargs):
    index_url = kwargs.pop('index_url', None)
    if index_url is None:
        index_url = 'https://oss-nexus.aws.saltstack.net/repository/salt-proxy/simple'
    extra_index_url = kwargs.pop('extra_index_url', None)
    if extra_index_url is None:
        extra_index_url = 'https://pypi.python.org/simple'

    bin_env = __salt__['pip.get_pip_bin'](kwargs.get('bin_env'), 'pip3')
    if isinstance(bin_env, list):
        bin_env = bin_env[0]
    log.warning('pip3 binary found: %s', bin_env)

    kwargs.update(
        index_url=index_url,
        extra_index_url=extra_index_url,
        bin_env=bin_env)
    return pip_state_installed(name, **kwargs)
