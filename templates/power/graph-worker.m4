include(`power/graph.m4')dnl
define(`display', `display1')dnl
dnl
powerGraphWorkerInit()

executeCommand:
powerGraphWorkerTryProcessCmd(TEMPLATE_WORKER, display, `%000000FF', TEMPLATE_CONFIG, executeCommand)
jump executeCommand always
