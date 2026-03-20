include(`scope.m4')dnl
dnl
dnl ### INVERSE_COND(condition) ###
dnl
define(`_handleConditionPair', `ifelse(`$1', `$2', `$3', `$1', `$3', `$2')')dnl
define(`INVERSE_COND',`dnl
_handleConditionPair(`$1', `equal', `notEqual')`'dnl
_handleConditionPair(`$1', `lessThan', `greaterThanEq')`'dnl
_handleConditionPair(`$1', `greaterThan', `lessThanEq')`'dnl
')dnl
dnl
dnl ### IF(a, condition, b, body, [else]) ###
dnl
define(`_ifSimple', `dnl
LABEL(`ifEnd')dnl
jump ifEnd INVERSE_COND(`$2') $1 $3
$4
ifEnd:dnl
')dnl
define(`_ifElse', `dnl
LABEL(`ifEnd')dnl
LABEL(`ifBegin')dnl
jump ifBegin $2 $1 $3
$5
jump ifEnd always _ _
ifBegin:
$4
ifEnd:dnl
')dnl
define(`IF', `BEGIN_SCOPE`'dnl
ifelse(`$5', `',
`ifelse(`$2', `strictEqual',
`_ifElse(`$1', `$2', `$3', `$4', `dnl')',
`_ifSimple(`$1', `$2', `$3', `$4')')',
`_ifElse(`$1', `$2', `$3', `$4', `$5')')dnl
END_SCOPE')dnl
dnl
dnl ### DOWHILELOOP(a, condition, b, body) ###
dnl
define(`DOWHILELOOP', `BEGIN_SCOPE`'dnl
LABEL(`downwhileBegin')dnl
downwhileBegin:
BEGIN_SCOPE`'dnl
$4
END_SCOPE`'dnl
jump downwhileBegin $2 $1 $3`'dnl
END_SCOPE')dnl
dnl
dnl ### WHILELOOP(a, condition, b, body, [init]) ###
dnl
define(`WHILELOOP', `BEGIN_SCOPE`'dnl
IF(`$1', `$2', `$3', `dnl
$5`'ifelse(`$5', `', `dnl')
DOWHILELOOP(`$1', `$2', `$3', `$4')')`'dnl
END_SCOPE')dnl
dnl
dnl ### FORLOOP(iter, start, end, delta, body) ###
dnl
define(`FORLOOP', `dnl
IF(`$2', `lessThan', `$3', `dnl
set $1 $2
DOWHILELOOP(`$1', `lessThan', `$3', `dnl
$5
op add $1 $1 $4')')`'dnl
')dnl
dnl
dnl ### LINKLOOP(index, iter, body) ###
dnl
define(`LINKLOOP', `FORLOOP(`$1', 0, `@links', 1, `dnl
getlink $2 $1
$3')')