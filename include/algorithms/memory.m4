include(`scope.m4')dnl
dnl
dnl ### memset(cell, start, value, size) ###
dnl
define(`memset',`BEGIN_SCOPE`'dnl
IDENTIFIER(`current')dnl
IDENTIFIER(`ending')dnl
LABEL(`memsetValue')dnl
LABEL(`memsetExit')dnl
set current $2
op add ending current $4
jump memsetExit greaterThanEq current ending
memsetValue:
write $3 $1 current
op add current current 1
jump memsetValue lessThan current ending
memsetExit:`'dnl
END_SCOPE')dnl
dnl
dnl ### memcpy(dstCell, dst, srcCell, src, size)
dnl
define(`memcpy', `BEGIN_SCOPE`'dnl
IDENTIFIER(`currentSrc')dnl
IDENTIFIER(`endingSrc')dnl
IDENTIFIER(`currentDst')dnl
IDENTIFIER(`buffer')dnl
LABEL(`memcpyValue')dnl
LABEL(`memcpyExit')dnl
set currentSrc $4
op add endingSrc currentSrc $5
set currentDst $2
jump memcpyExit greaterThanEq currentSrc endingSrc
memcpyValue:
read buffer $3 currentSrc
write buffer $1 currentDst
op add currentSrc currentSrc 1
op add currentDst currentDst 1
jump memcpyValue lessThan currentSrc endingSrc
memcpyExit:`'dnl
END_SCOPE')dnl
dnl
dnl ### memmove(destCell, dst, srcCell, src, size) ###
dnl
define(`memmove', `BEGIN_SCOPE`'dnl
IDENTIFIER(`currentSrc')dnl
IDENTIFIER(`endingSrc')dnl
IDENTIFIER(`currentDst')dnl
IDENTIFIER(`delta')dnl
IDENTIFIER(`buffer')dnl
LABEL(`memmoveValue')dnl
LABEL(`memmoveExit')dnl
LABEL(`memmoveReversed')dnl
LABEL(`memmoveBegin')dnl
jump memmoveReversed greaterThan $2 $4
set currentSrc $4
op add endingSrc currentSrc $5
set currentDst $2
set delta 1
jump memmoveBegin always _ _
memmoveReversed:
op sub currentSrc $5 1
op add currentDst currentSrc $2
op add currentSrc currentSrc $4
op sub endingSrc $4 1
set delta -1
memmoveBegin:
jump memmoveExit equal currentSrc endingSrc
memmoveValue:
read buffer $3 currentSrc
write buffer $1 currentDst
op add currentSrc currentSrc delta
op add currentDst currentDst delta
jump memmoveValue notEqual currentSrc endingSrc
memmoveExit:`'dnl
END_SCOPE')dnl
dnl
dnl ### swap(cellX, x, cellY, y) ###
dnl
define(`swap', `BEGIN_SCOPE`'dnl
IDENTIFIER(`bufX')dnl
IDENTIFIER(`bufY')dnl
read bufX $1 $2
read bufY $3 $4
write bufX $3 $4
write bufY $1 $2`'dnl
END_SCOPE')