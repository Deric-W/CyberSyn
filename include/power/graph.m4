include(`scope.m4')dnl
include(`control-flow.m4')dnl
include(`algorithms/memory.m4')dnl
include(`communication/sync/workers.m4')dnl
include(`graphics/layout.m4')dnl
include(`graphics/borders.m4')dnl
include(`graphics/graphs.m4')dnl
dnl
dnl ### POWER_GRAPH_CONFIG(name, attribute, value) ###
dnl
define(`POWER_GRAPH_CONFIG', `define(format(``_POWER_GRAPH_CONFIG_%s_%s'', `$1', `$2'), `$3')')dnl
dnl
dnl ### POWER_GRAPH_GET_CONFIG(name, attribute) ###
dnl
define(`POWER_GRAPH_GET_CONFIG', `defn(format(``_POWER_GRAPH_CONFIG_%s_%s'', `$1', `$2'))')dnl
dnl
dnl ### powerGraphInit(currentVariable, config) ###
dnl
define(`powerGraphInit', `dnl
set $1 0
memset(
    POWER_GRAPH_GET_CONFIG(`$2', `STORED_CELL'),
    POWER_GRAPH_GET_CONFIG(`$2', `STORED_OFFSET'),
    0,
    GRAPH_GET_CONFIG(POWER_GRAPH_GET_CONFIG(`$2', `GRAPH'), `POINTS'))
memset(
    POWER_GRAPH_GET_CONFIG(`$2', `IN_CELL'),
    POWER_GRAPH_GET_CONFIG(`$2', `IN_OFFSET'),
    0,
    GRAPH_GET_CONFIG(POWER_GRAPH_GET_CONFIG(`$2', `GRAPH'), `POINTS'))
memset(
    POWER_GRAPH_GET_CONFIG(`$2', `OUT_CELL'),
    POWER_GRAPH_GET_CONFIG(`$2', `OUT_OFFSET'),
    0,
    GRAPH_GET_CONFIG(POWER_GRAPH_GET_CONFIG(`$2', `GRAPH'), `POINTS'))`'dnl
')dnl
dnl
dnl ### powerGraphSamplePoint(node, currentVariable, config) ###
dnl
define(`powerGraphSamplePoint', `BEGIN_SCOPE`'dnl
IDENTIFIER(`value1')dnl
IDENTIFIER(`value2')dnl
graphNext(POWER_GRAPH_GET_CONFIG(`$3', `GRAPH'), `$2', `$2')

sensor value1 $1 @powerNetStored
sensor value2 $1 @powerNetCapacity
op div value1 value1 value2
op add value2 POWER_GRAPH_GET_CONFIG(`$3', `STORED_OFFSET') $2
write value1 POWER_GRAPH_GET_CONFIG(`$3', `STORED_CELL') value2

sensor value1 $1 @powerNetIn
op add value2 POWER_GRAPH_GET_CONFIG(`$3', `IN_OFFSET') $2
write value1 POWER_GRAPH_GET_CONFIG(`$3', `IN_CELL') value2

sensor value1 $1 @powerNetOut
op add value2 POWER_GRAPH_GET_CONFIG(`$3', `OUT_OFFSET') $2
write value1 POWER_GRAPH_GET_CONFIG(`$3', `OUT_CELL') value2`'dnl
END_SCOPE')dnl
dnl
dnl ### powerGraphStartPreparation(worker) ###
dnl
define(`powerGraphStartPreparation', `workerSubmitTask(`$1', "_POWER_GRAPH_CMD_PREPARE")')dnl
dnl
dnl ### powerGraphStartDraw(currentVariable, prepareState, worker) ###
dnl
define(`powerGraphStartDraw', `dnl
write $1 $3 "WORKER_ARG(0)"
write $2 $3 "WORKER_ARG(1)"
workerSubmitTask(`$3', "_POWER_GRAPH_CMD_DRAW")`'dnl
')dnl
dnl
dnl ### powerGraphStartFlush(worker) ###
dnl
define(`powerGraphStartFlush', `workerSubmitTask(`$1', "_POWER_GRAPH_CMD_FLUSH")')dnl
dnl
dnl ### powerGraphMergePreparationResults(partitionResult, worker, resultVariable) ###
dnl
define(`powerGraphMergePreparationResults', `BEGIN_SCOPE`'dnl
IDENTIFIER(`result')dnl
read result $2 "WORKER_ARG(0)"
op max $3 $1 result`'dnl
END_SCOPE')dnl
dnl
dnl ### powerGraphPrepare(partition, config, resultVariable) ###
dnl
define(`powerGraphPrepare', `BEGIN_SCOPE`'dnl
IDENTIFIER(`tmp')dnl
graphPreparePartition(
    POWER_GRAPH_GET_CONFIG(`$2', `GRAPH'),
    `$1',
    POWER_GRAPH_GET_CONFIG(`$2', `IN_CELL'),
    POWER_GRAPH_GET_CONFIG(`$2', `IN_OFFSET'),
    tmp)
graphPreparePartition(
    POWER_GRAPH_GET_CONFIG(`$2', `GRAPH'),
    `$1',
    POWER_GRAPH_GET_CONFIG(`$2', `OUT_CELL'),
    POWER_GRAPH_GET_CONFIG(`$2', `OUT_OFFSET'),
    `$3')
graphMergePreparationResults(tmp, `$3', `$3')`'dnl
END_SCOPE')dnl
dnl
dnl ### powerGraphBeginDraw(currentVariable, config) ###
dnl
define(`powerGraphBeginDraw', `BEGIN_SCOPE`'dnl
IDENTIFIER(`offset')dnl
IDENTIFIER(`powerIn')dnl
IDENTIFIER(`powerOut')dnl
BORDER_INNER_LAYOUT(
    POWER_GRAPH_GET_CONFIG(`$2', `GRAPH_BORDER'),
    POWER_GRAPH_GET_CONFIG(`$2', `GRAPH_LAYOUT'),
    `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')dnl
op add offset POWER_GRAPH_GET_CONFIG(`$2', `IN_OFFSET') $1
read powerIn POWER_GRAPH_GET_CONFIG(`$2', `IN_CELL') offset
op add offset POWER_GRAPH_GET_CONFIG(`$2', `OUT_OFFSET') $1
read powerOut POWER_GRAPH_GET_CONFIG(`$2', `OUT_CELL') offset
IF(powerOut, greaterThan, powerIn, `dnl
draw color 250 0 0 127
draw rect LAYOUT_X(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT') LAYOUT_Y(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT') LAYOUT_WIDTH(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT') LAYOUT_HEIGHT(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')`'dnl
')`'dnl
END_SCOPE')dnl
dnl
dnl ### powerGraphDraw(partition, currentVariable, prepareState, background, config) ###
dnl
define(`powerGraphDraw', `BEGIN_SCOPE`'dnl
LABEL(`doDraw')dnl
LABEL(`finishDraw')dnl
IDENTIFIER(`maxValue')dnl
IDENTIFIER(`cell')dnl
IDENTIFIER(`offset')dnl
IDENTIFIER(`nextIteration')dnl
set maxValue 1
set cell POWER_GRAPH_GET_CONFIG(`$5', `STORED_CELL')
set offset POWER_GRAPH_GET_CONFIG(`$5', `STORED_OFFSET')
draw color 255 220 0 255
op add nextIteration @counter 1
jump doDraw always

set maxValue $3
set cell POWER_GRAPH_GET_CONFIG(`$5', `OUT_CELL')
set offset POWER_GRAPH_GET_CONFIG(`$5', `OUT_OFFSET')
draw color 255 0 0 255
op add nextIteration @counter 1
jump doDraw always

set cell POWER_GRAPH_GET_CONFIG(`$5', `IN_CELL')
set offset POWER_GRAPH_GET_CONFIG(`$5', `IN_OFFSET')
draw color 0 255 0 255
op add nextIteration @counter 1
jump doDraw always
jump finishDraw always

doDraw:
BORDER_INNER_LAYOUT(
    POWER_GRAPH_GET_CONFIG(`$5', `GRAPH_BORDER'),
    POWER_GRAPH_GET_CONFIG(`$5', `GRAPH_LAYOUT'),
    `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')dnl
graphDrawPartition(
    POWER_GRAPH_GET_CONFIG(`$5', `GRAPH'),
    `$1',
    `$2',
    maxValue,
    cell,
    offset,
    `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')
set @counter nextIteration
finishDraw:
END_SCOPE`'dnl
BEGIN_SCOPE`'dnl
IDENTIFIER(`stored')dnl
IDENTIFIER(`offset')dnl
BORDER_INNER_LAYOUT(
    POWER_GRAPH_GET_CONFIG(`$5', `GRAPH_BORDER'),
    POWER_GRAPH_GET_CONFIG(`$5', `GRAPH_LAYOUT'),
    `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')dnl
draw col $4
graphMaskPadding(POWER_GRAPH_GET_CONFIG(`$5', `GRAPH'), `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')

BORDER_INNER_LAYOUT(
    POWER_GRAPH_GET_CONFIG(`$5', `BAR_BORDER'),
    POWER_GRAPH_GET_CONFIG(`$5', `BAR_LAYOUT'),
    `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')dnl
op add offset POWER_GRAPH_GET_CONFIG(`$5', `STORED_OFFSET') $2
read stored POWER_GRAPH_GET_CONFIG(`$5', `STORED_CELL') offset
op mul stored stored LAYOUT_HEIGHT(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')
draw color 255 220 0 255
draw rect LAYOUT_X(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT') LAYOUT_Y(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT') LAYOUT_WIDTH(`_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT') stored

draw color 75 75 75 255
drawBorder(POWER_GRAPH_GET_CONFIG(`$5', `GRAPH_BORDER'), POWER_GRAPH_GET_CONFIG(`$5', `GRAPH_LAYOUT'))
drawBorder(POWER_GRAPH_GET_CONFIG(`$5', `BAR_BORDER'), POWER_GRAPH_GET_CONFIG(`$5', `BAR_LAYOUT'))`'dnl
END_SCOPE')dnl
dnl
dnl ### powerGraphPrintStats(node) ###
dnl
define(`powerGraphPrintStats', `BEGIN_SCOPE`'dnl
IDENTIFIER(`value1')dnl
IDENTIFIER(`value2')dnl
print "Power Graph v1.0 \n[lime]Production:[] {0}\n[red]Consumtion:[] {1}\n`'dnl
[blue]Difference:[] {2}\n[yellow]Stored:[] {3}\n[orange]Capacity:[] {4}"
sensor value1 $1 @powerNetIn
op round value1 value1
format value1
sensor value2 $1 @powerNetOut
op round value2 value2
format value2
op sub value1 value1 value2
format value1
sensor value1 $1 @powerNetStored
op round value1 value1
format value1
sensor value1 $1 @powerNetCapacity
format value1`'dnl
END_SCOPE')dnl
dnl
dnl ### powerGraphWorkerInit() ###
dnl
define(`powerGraphWorkerInit', `dnl
workerInit(0, 1)
drawflush null`'dnl
')dnl
dnl
dnl ### powerGraphWorkerTryProcessCmd(partition, display, background, config, pendingLabel) ###
dnl
define(`powerGraphWorkerTryProcessCmd', `BEGIN_SCOPE`'dnl
LABEL(`prepareCmd')dnl
LABEL(`drawCmd')dnl
LABEL(`flushCmd')dnl
LABEL(`afterCmd')dnl
BORDER_INNER_LAYOUT(
    POWER_GRAPH_GET_CONFIG(`$4', `GRAPH_BORDER'),
    POWER_GRAPH_GET_CONFIG(`$4', `GRAPH_LAYOUT'),
    `_POWER_GRAPH_GRAPH_TMP_INNER_LAYOUT')dnl
BEGIN_SCOPE`'dnl
IDENTIFIER(`task')dnl
workerPollTask(task, `$5')
jump prepareCmd strictEqual task "_POWER_GRAPH_CMD_PREPARE"
jump drawCmd strictEqual task "_POWER_GRAPH_CMD_DRAW"
jump flushCmd strictEqual task "_POWER_GRAPH_CMD_FLUSH"
END_SCOPE`'dnl
jump $5 always

prepareCmd:
powerGraphPrepare(`$1', `$4', WORKER_ARG(0))
jump afterCmd always

drawCmd:
draw reset
powerGraphDraw(`$1', WORKER_ARG(0), WORKER_ARG(1), `$3', `$4')
jump afterCmd always

flushCmd:
drawflush $2

afterCmd:
workerFinishTask()`'dnl
END_SCOPE')dnl
dnl
dnl ### Predefined POWER_GRAPH_LOGIC_DISPLAY Configuration ###
dnl
BORDER_CONFIG(`_POWER_GRAPH_LOGIC_DISPLAY_BORDER', `STYLE', `SIMPLE')dnl
BORDER_CONFIG(`_POWER_GRAPH_LOGIC_DISPLAY_BORDER', `STROKE', 2)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LOGIC_DISPLAY_GRAPH', `POINTS', 20)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LOGIC_DISPLAY_GRAPH', `PARTITIONS', 4)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LOGIC_DISPLAY_GRAPH', `POINT_DISTANCE', 3)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LOGIC_DISPLAY_GRAPH', `STROKE', 1)dnl
LAYOUT_PAD(`DISPLAY', 3, `_POWER_GRAPH_TMP_LAYOUT')dnl
LAYOUT_SUBDIVIDE(
    `_POWER_GRAPH_TMP_LAYOUT',
    `RIGHT',
    eval(GRAPH_WIDTH(`_POWER_GRAPH_LOGIC_DISPLAY_GRAPH') + (2 * 2)),
    `_POWER_GRAPH_LOGIC_DISPLAY_GRAPH_LAYOUT',
    `_POWER_GRAPH_TMP_LEFT_LAYOUT')dnl
LAYOUT_SUBDIVIDE(
    `_POWER_GRAPH_TMP_LEFT_LAYOUT',
    `RIGHT',
    3,
    _,
    `_POWER_GRAPH_LOGIC_DISPLAY_BORDER_LAYOUT')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `STORED_CELL', `cell1')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `STORED_OFFSET', 0)dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `IN_CELL', `cell1')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `IN_OFFSET', 21)dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `OUT_CELL', `cell1')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `OUT_OFFSET', 42)dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `BAR_LAYOUT', `_POWER_GRAPH_LOGIC_DISPLAY_BORDER_LAYOUT')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `BAR_BORDER', `_POWER_GRAPH_LOGIC_DISPLAY_BORDER')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `GRAPH', `_POWER_GRAPH_LOGIC_DISPLAY_GRAPH')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `GRAPH_LAYOUT', `_POWER_GRAPH_LOGIC_DISPLAY_GRAPH_LAYOUT')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LOGIC_DISPLAY', `GRAPH_BORDER', `_POWER_GRAPH_LOGIC_DISPLAY_BORDER')dnl
dnl
dnl ### Predefined POWER_GRAPH_LARGE_DISPLAY Configuration ###
dnl
BORDER_CONFIG(`_POWER_GRAPH_LARGE_DISPLAY_BORDER', `STYLE', `SIMPLE')dnl
BORDER_CONFIG(`_POWER_GRAPH_LARGE_DISPLAY_BORDER', `STROKE', 3)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LARGE_DISPLAY_GRAPH', `POINTS', 30)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LARGE_DISPLAY_GRAPH', `PARTITIONS', 6)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LARGE_DISPLAY_GRAPH', `POINT_DISTANCE', 5)dnl
GRAPH_CONFIG(`_POWER_GRAPH_LARGE_DISPLAY_GRAPH', `STROKE', 2)dnl
LAYOUT_PAD(`LARGE_DISPLAY', 3, `_POWER_GRAPH_TMP_LAYOUT')dnl
LAYOUT_SUBDIVIDE(
    `_POWER_GRAPH_TMP_LAYOUT',
    `RIGHT',
    eval(GRAPH_WIDTH(`_POWER_GRAPH_LARGE_DISPLAY_GRAPH') + (3 * 2)),
    `_POWER_GRAPH_LARGE_DISPLAY_GRAPH_LAYOUT',
    `_POWER_GRAPH_TMP_LEFT_LAYOUT')dnl
LAYOUT_SUBDIVIDE(
    `_POWER_GRAPH_TMP_LEFT_LAYOUT',
    `RIGHT',
    4,
    _,
    `_POWER_GRAPH_LARGE_DISPLAY_BORDER_LAYOUT')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `STORED_CELL', `cell1')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `STORED_OFFSET', 0)dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `IN_CELL', `cell1')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `IN_OFFSET', 30)dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `OUT_CELL', `cell2')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `OUT_OFFSET', 0)dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `BAR_LAYOUT', `_POWER_GRAPH_LARGE_DISPLAY_BORDER_LAYOUT')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `BAR_BORDER', `_POWER_GRAPH_LARGE_DISPLAY_BORDER')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `GRAPH', `_POWER_GRAPH_LARGE_DISPLAY_GRAPH')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `GRAPH_LAYOUT', `_POWER_GRAPH_LARGE_DISPLAY_GRAPH_LAYOUT')dnl
POWER_GRAPH_CONFIG(`POWER_GRAPH_LARGE_DISPLAY', `GRAPH_BORDER', `_POWER_GRAPH_LARGE_DISPLAY_BORDER')