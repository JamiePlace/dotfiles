try:
    from Ipython import get_config
except ModuleNotFoundError:
    pass

c = get_config()  #noqa

c.InteractiveShellApp.exec_lines = []
c.InteractiveShellApp.exec_lines.append('%load_ext autoreload')
c.InteractiveShellApp.exec_lines.append('%autoreload 2')
c.InteractiveShellApp.exec_lines.append('print("Warning: using ipython config")')
