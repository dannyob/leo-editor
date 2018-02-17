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
def proto_leo_el_vue(event):
    '''
    Vitalije's electron/vue project:: Leo in CoffeeScript and Vue.
    
    Original sources and documentation at: https://leoelvue.computingart.net/home
    '''
    c = event and event.get('c')
    base_dir = g.os_path_finalize_join(g.app.loadDir,
        '..', 'proto', 'Vitalije', 'leo-el-vue')
    g.execute_shell_commands_with_options(
        c = c,
        base_dir=base_dir,
        commands = ['&npm run dev',],
        command_setting = 'leo-el-vue-commands',
            # @data leo-el-vue-commands
        path_setting= 'leo-el-vue-base',
            # @string leo-el-vue-base
    )
#@+node:ekr.20180217093505.1: ** @g.command('leoserver')
@g.command('leoserver')
@g.command('proto-leo-server')
def proto_leoserver(event):
    '''
    Terry's "fully functional Leo web interface :-)
    
    First announced here, in a comment to #684:
    https://github.com/leo-editor/leo-editor/issues/684#issuecomment-363992724

    The code is here:
    https://github.com/leo-editor/leo-editor/files/1705639/leoserver.zip
    '''
    # c = event and event.get('c')
    base = g.os_path_finalize_join(g.app.loadDir,
        '..', 'proto', 'Terry', 'leoserver')
    base = base.replace('\\','/')
    if g.os_path_exists(base):
        g.es_print('WARNING: killing the server will also kill Leo')
        os.chdir(base) # Can't do this in the commands list.
        g.execute_shell_commands(commands=['&python leoserver.py',])
    else:
        g.es_print('not found: %r' % base)
#@-others
#@-leo
