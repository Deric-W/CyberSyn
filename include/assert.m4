include(`scope.m4')dnl
dnl
dnl ### IF_DEBUG(body, [else]) ###
dnl
define(`IF_DEBUG', `ifdef(`DEBUG', `$1', `$2')')dnl
dnl
dnl ### assert(a, condition, b, [message]) ###
dnl
define(`assert', `IF_DEBUG(`_assert(`$1', `$2', `$3', _assertMsg($@))')')dnl
define(`_assertMsg', `format(``[lime]Assertion $1 $2 $3 failed%s'', ifelse(`$4', `', `[]', ``:[] $4''))')dnl
define(`_assert', `BEGIN_SCOPE`'dnl
LABEL(`assertSuccess')dnl
jump assertSuccess $2 $1 $3
set ASSERT_MSG "[yellow]__file__:__line__:[] $4"
stop
assertSuccess:`'dnl
END_SCOPE')