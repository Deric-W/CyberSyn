include(`scope.m4')dnl
include(`control-flow.m4')dnl
include(`graphics/layout.m4')dnl
dnl
dnl ### Helper Macros ###
dnl
define(`_assert', `ifelse(eval(`$1'), 1, `', `errprint(__program__:__file__:__line__: `Assertion $1 failed
')m4exit(`1')')')dnl
define(`_min', `ifelse(eval(`$1 <= $2'), 1, `$1', `$2')')dnl
define(`_divUp', `eval(`(($1) + ($2) - 1) / ($2)')')dnl
define(`_isqrt', `ifelse(
`$1', 0, 0,
`__isqrt(-1, 1, eval(`(1 + $1) / 2'), `$1')'dnl
)')dnl
define(`__isqrt', `ifelse(
`$3', `$2', `$3',
`$3', `$1', `_min(`$2', `$3')',
`$0(`$2', `$3', eval(`($3 + ($4 / $3)) / 2'), `$4')')dnl
')dnl
define(`_isqrtUp', `__isqrtUp(_isqrt(`$1'), `$1')')dnl
define(`__isqrtUp', `ifelse(eval(`$1 ** 2'), `$2', `$1', `eval(`$1 + 1')')')dnl
define(`_partitionStart', `eval(_divUp(`$1', `$2') * $3)')dnl
define(`_partitionEnd', `_min(_partitionStart(`$1', `$2', eval(`$3 + 1')), `$1')')dnl
define(`_GRAPH_INTERVAL_PARTITION_START', `_assert($2 < _GRAPH_CONFIG_$1_PARTITIONS)_partitionStart(eval(_GRAPH_CONFIG_$1_POINTS - 1), _GRAPH_CONFIG_$1_PARTITIONS, `$2')')dnl
define(`_GRAPH_INTERVAL_PARTITION_END', `_assert($2 < _GRAPH_CONFIG_$1_PARTITIONS)_partitionEnd(eval(_GRAPH_CONFIG_$1_POINTS - 1), _GRAPH_CONFIG_$1_PARTITIONS, `$2')')dnl
dnl
dnl ### GRAPH_CONFIG(name, attribute, value) ###
dnl
define(`GRAPH_CONFIG', `define(`_$0_$1_$2', `$3')')dnl
dnl
dnl ### GRAPH_WIDTH(name) ###
dnl
define(`GRAPH_WIDTH', `eval((_GRAPH_CONFIG_$1_POINTS - 1) * _GRAPH_CONFIG_$1_POINT_DISTANCE)')dnl
dnl
dnl ### GRAPH_PADDING(name) ###
dnl
define(`GRAPH_PADDING', `eval(_isqrtUp(eval(((_GRAPH_CONFIG_$1_STROKE / 2) ** 2) * 2)))')dnl
dnl
dnl ### GRAPH_PARTITION_START(name, number) ###
dnl
define(`GRAPH_PARTITION_START', `_assert($2 < _GRAPH_CONFIG_$1_PARTITIONS)_partitionStart(_GRAPH_CONFIG_$1_POINTS, _GRAPH_CONFIG_$1_PARTITIONS, `$2')')dnl
dnl
dnl ### GRAPH_PARTITION_END(name, number) ###
dnl
define(`GRAPH_PARTITION_END', `_assert($2 < _GRAPH_CONFIG_$1_PARTITIONS)_partitionEnd(_GRAPH_CONFIG_$1_POINTS, _GRAPH_CONFIG_$1_PARTITIONS, `$2')')dnl
dnl
dnl ### graphNext(name, current, resultVariable, [delta]) ###
dnl
define(`graphNext', `dnl
op add $3 $2 ifelse(`$4', `', 1, `$4')
op mod $3 $3 _GRAPH_CONFIG_$1_POINTS`'dnl
')dnl
dnl
dnl ### graphPreparePartition(name, number, cell, offset, resultVariable) ###
dnl
define(`graphPreparePartition', `ifelse(GRAPH_PARTITION_START(`$1', `$2'), GRAPH_PARTITION_END(`$1', `$2'), `', `BEGIN_SCOPE`'dnl
IDENTIFIER(`current')dnl
IDENTIFIER(`until')dnl
set $5 0
op add current GRAPH_PARTITION_START(`$1', `$2') $4
op add until GRAPH_PARTITION_END(`$1', `$2') $4
DOWHILELOOP(current, notEqual, until, `dnl
IDENTIFIER(`value')dnl
read value $3 current
op max $5 $5 value
op add current current 1')`'dnl
END_SCOPE')')dnl
dnl
dnl ### graphMergePreparationResults(partitionResult1, partitionResult2, resultVariable) ###
dnl
define(`graphMergePreparationResults', `op max $3 $1 $2')dnl
dnl
dnl ### _graphCalculatePointY(current, cell, offset, prepareState, layout, resultVariable) ###
dnl
define(`_graphCalculatePointY', `dnl
op add $6 $1 $3
read $6 $2 $6
op div $6 $6 $4
op mul $6 $6 LAYOUT_HEIGHT(`$5')
op add $6 $6 LAYOUT_Y(`$5')`'dnl
')dnl
dnl
dnl ### graphDrawPartition(name, number, current, prepareState, cell, offset, layout) ###
dnl
define(`graphDrawPartition', `ifelse(_GRAPH_INTERVAL_PARTITION_START(`$1', `$2'), _GRAPH_INTERVAL_PARTITION_END(`$1', `$2'), `', `BEGIN_SCOPE`'dnl
IDENTIFIER(`index')dnl
IDENTIFIER(`until')dnl
IDENTIFIER(`currentX')dnl
IDENTIFIER(`currentY')dnl
graphNext(`$1', `$3', index, eval(_GRAPH_INTERVAL_PARTITION_START(`$1', `$2') + 1))
graphNext(`$1', `$3', until, eval(_GRAPH_INTERVAL_PARTITION_END(`$1', `$2') + 1))
set currentX eval(LAYOUT_X(`$7') + (_GRAPH_CONFIG_$1_POINT_DISTANCE * _GRAPH_INTERVAL_PARTITION_START(`$1', `$2')))
_graphCalculatePointY(index, `$5', `$6', `$4', `$7', currentY)
draw stroke _GRAPH_CONFIG_$1_STROKE
DOWHILELOOP(index, notEqual, until, `dnl
IDENTIFIER(`prevX')dnl
IDENTIFIER(`prevY')dnl
set prevX currentX
set prevY currentY
graphNext(`$1', index, index)
_graphCalculatePointY(index, `$5', `$6', `$4', `$7', currentY)
op add currentX currentX _GRAPH_CONFIG_$1_POINT_DISTANCE
draw line prevX prevY currentX currentY')`'dnl
END_SCOPE')')dnl
dnl
dnl ### graphMaskPadding(name, layout) ###
dnl
define(`graphMaskPadding', `ifelse(GRAPH_PADDING(`$1'), 0, `', `dnl
LAYOUT_PAD(`$2', eval(-GRAPH_PADDING(`$1')), `_GRAPH_OUTER_LAYOUT')dnl
draw stroke GRAPH_PADDING(`$1')
draw lineRect LAYOUT_X(`_GRAPH_OUTER_LAYOUT') LAYOUT_Y(`_GRAPH_OUTER_LAYOUT') LAYOUT_WIDTH(`_GRAPH_OUTER_LAYOUT') LAYOUT_HEIGHT(`_GRAPH_OUTER_LAYOUT')`'dnl
')')