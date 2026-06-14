dnl
dnl ### COMPTIME_TODO([message]) ###
dnl
define(`COMPTIME_TODO', `_COMPTIME_TODO(ifelse(`$1', `', ``TODO'', ``TODO: $1''))')dnl
define(`_COMPTIME_TODO', `errprint(__program__:__file__:__line__: `$1
')m4exit(1)')dnl
dnl
dnl ### COMPTIME_ASSERT(expr, [message]) ###
dnl
define(`COMPTIME_ASSERT', `_COMPTIME_ASSERT(`$1', ifelse(`$2', `', ``Assertion $1 failed'', ``Assertion $1 failed: $2''))')dnl
define(`_COMPTIME_ASSERT', `ifelse(eval(`$1'), 0, `errprint(__program__:__file__:__line__: `$2
')m4exit(1)')')dnl
dnl
dnl ### COMPTIME_FORLOOP(iter, start, end, delta, body) ###
dnl
define(`COMPTIME_FORLOOP', `pushdef(`$1')_COMPTIME_FORLOOP($@)popdef(`$1')')dnl
define(`_COMPTIME_FORLOOP', `ifelse(
_COMPTIME_FORLOOP_CHCOND(`$2', `$3', `$4'), 0, `',
`define(`$1', `$2')dnl
$5`'dnl
$0(`$1', eval(`($2) + ($4)'), `$3', `$4', `$5')'dnl
)')dnl
define(`_COMPTIME_FORLOOP_CHCOND', `ifelse(
eval(`($3) < 0'), 0, `eval(`($1) < ($2)')',
`eval(`($1) > ($2)')'dnl
)')dnl
dnl
dnl ### COMPTIME_FOREACH(iter, values, body) ###
dnl
define(`COMPTIME_FOREACH', `pushdef(`$1')_COMPTIME_FOREACH($@)popdef(`$1')')dnl
define(`_COMPTIME_FOREACH', `ifelse(
`$2', ``'', `',
`define(`$1', _COMPTIME_HEAD($2))dnl
$3`'dnl
$0(`$1', _COMPTIME_ALL(shift($2)), `$3')'dnl
)')dnl
define(`_COMPTIME_HEAD', ``$1'')dnl
define(`_COMPTIME_ALL', ``$@'')dnl
dnl
dnl ### COMPTIME_MIN(a, b) ###
dnl
define(`COMPTIME_MIN', `ifelse(eval(`($1) > ($2)'), 0, `$1', `$2')')dnl
dnl
dnl ### COMPTIME_MAX(a, b) ###
dnl
define(`COMPTIME_MAX', `ifelse(eval(`($1) < ($2)'), 0, `$1', `$2')')dnl
dnl
dnl ### COMPTIME_DIV_UP(a, b) ###
dnl
define(`COMPTIME_DIV_UP', `eval(`(($1) + ($2) - 1) / ($2)')')dnl
dnl
dnl ### COMPTIME_ISQRT(x) ###
dnl
define(`COMPTIME_ISQRT', `COMPTIME_ASSERT(`($1) >= 0', `negative numbers are not supported')dnl
ifelse(
`$1', 0, 0,
`_COMPTIME_ISQRT(-1, 1, eval(`(1 + ($1)) / 2'), `$1')'dnl
)')dnl
define(`_COMPTIME_ISQRT', `ifelse(
`$3', `$2', `$3',
`$3', `$1', `COMPTIME_MIN(`$2', `$3')',
`$0(`$2', `$3', eval(`(($3) + (($4) / ($3))) / 2'), `$4')'dnl
)')dnl
dnl
dnl ### COMPTIME_ISQRT_UP(x) ###
dnl
define(`COMPTIME_ISQRT_UP', `_COMPTIME_ISQRT_UP(COMPTIME_ISQRT(`$1'), `$1')')dnl
define(`_COMPTIME_ISQRT_UP', `ifelse(eval(`($1) ** 2'), `$2', `$1', `eval(`($1) + 1')')')