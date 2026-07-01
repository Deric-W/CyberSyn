include(`comptime.m4')dnl
include(`scope.m4')dnl
include(`power/graph.m4')dnl
define(`message', `message1')dnl
define(`switch', `switch1')dnl
define(`node', `node1')dnl
define(`display', `display1')dnl
define(`waitWorkers', `COMPTIME_FOREACH(`worker', defn(`TEMPLATE_WORKERS'), `BEGIN_SCOPE`'dnl
LABEL(`retryWait')dnl
retryWait:
powerGraphTryWaitWorker(worker, retryWait)
END_SCOPE')')dnl
define(`resetWorkers', `COMPTIME_FOREACH(`worker', defn(`TEMPLATE_WORKERS'), `dnl
powerGraphResetWorker(worker)
')')dnl
define(`startPreparationWorkers', `COMPTIME_FOREACH(`worker', defn(`TEMPLATE_WORKERS'), `dnl
powerGraphStartPreparation(worker)
')')dnl
define(`mergePreparationResults', `COMPTIME_FOREACH(`worker', defn(`TEMPLATE_WORKERS'), `dnl
powerGraphMergePreparationResults(`$1', worker, `$1')
')')dnl
define(`startDrawWorkers', `COMPTIME_FOREACH(`worker', defn(`TEMPLATE_WORKERS'), `dnl
powerGraphStartDraw(`$1', `$2', worker)
')')dnl
define(`flushWorkers', `COMPTIME_FOREACH(`worker', defn(`TEMPLATE_WORKERS'), `dnl
powerGraphStartFlush(worker)
')')dnl
dnl
init:
drawflush null
resetWorkers()
powerGraphInit(current, TEMPLATE_CONFIG)
control enabled switch false

drawLoop:
# handle the reset button being pressed
sensor resetRequested switch @enabled
jump init strictEqual resetRequested true

# reset drawing state
draw reset
draw clear 0 0 0

powerGraphSamplePoint(node, current, TEMPLATE_CONFIG)

# prepare graph for drawing
startPreparationWorkers()
powerGraphPrepare(0, TEMPLATE_CONFIG, prepared)
waitWorkers()
mergePreparationResults(prepared)

# draw updated graph
startDrawWorkers(current, prepared)
powerGraphBeginDraw(current, TEMPLATE_CONFIG)
powerGraphDraw(0, current, prepared, `%000000FF', TEMPLATE_CONFIG)
waitWorkers()

# flush results to display
drawflush display
flushWorkers()

# update stats while we wait for the workers
powerGraphPrintStats(node)
printflush message

waitWorkers()
jump drawLoop always
