# -*- coding: utf-8 -*-
#@+leo-ver=5-thin
#@+node:ekr.20180217083023.1: * @file leoPrototype.py
#@@first
'''
Commands that run various prototype projects.

The docstrings for various commands are reference documentation.
'''
import leo.core.leoGlobals as g
import os
#@+others
#@+node:ekr.20180217083208.1: ** @g.command('leo-el-vue')
@g.command('leo-el-vue')
@g.command('proto-leo-el-vue')
def leo_el_vue(event):
    '''
    Vitalije's electron/vue project:: Leo in CoffeeScript and Vue.
    
    Original sources and documentation at: https://leoelvue.computingart.net/home
    '''
    # c = event and event.get('c')
    base = g.os_path_finalize_join(g.app.loadDir,
        '..', 'proto', 'Vitalije', 'leo-el-vue')
    base = base.replace('\\','/')
    commands = [
        'npm run dev',
    ]
    if g.os_path_exists(base):
        os.chdir(base) # Can't do this in the commands list.
        g.execute_shell_commands(commands)
    else:
        g.es_print('not found: %r' % base)
#@-others
#@-leo
