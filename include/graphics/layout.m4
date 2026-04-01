dnl
dnl ### LAYOUT_X(name) ###
dnl
define(`LAYOUT_X', `_$0_$1')dnl
dnl
dnl ### LAYOUT_Y(name) ###
dnl
define(`LAYOUT_Y', `_$0_$1')dnl
dnl
dnl ### LAYOUT_WIDTH(name) ###
dnl
define(`LAYOUT_WIDTH', `_$0_$1')dnl
dnl
dnl ### LAYOUT_HEIGHT(name) ###
dnl
define(`LAYOUT_HEIGHT', `_$0_$1')dnl
dnl
dnl ### LAYOUT_SUBDIVIDE(name, direction, length, result, remaining) ###
dnl
define(`LAYOUT_SUBDIVIDE', `indir(`_$0_$2', `$1', `$3', `$4', `$5')')dnl
define(`_LAYOUT_SUBDIVIDE_LEFT', `dnl
define(`_LAYOUT_X_$3', _LAYOUT_X_$1)dnl
define(`_LAYOUT_Y_$3', _LAYOUT_Y_$1)dnl
define(`_LAYOUT_WIDTH_$3', $2)dnl
define(`_LAYOUT_HEIGHT_$3', _LAYOUT_HEIGHT_$1)dnl
define(`_LAYOUT_X_$4', eval(_LAYOUT_X_$1 + $2))dnl
define(`_LAYOUT_Y_$4', _LAYOUT_Y_$1)dnl
define(`_LAYOUT_WIDTH_$4', eval(_LAYOUT_WIDTH_$1 - $2))dnl
define(`_LAYOUT_HEIGHT_$4', _LAYOUT_HEIGHT_$1)dnl
')dnl
define(`_LAYOUT_SUBDIVIDE_RIGHT', `LAYOUT_SUBDIVIDE(`$1', `LEFT', eval(LAYOUT_WIDTH(`$1') - $2), `$4', `$3')')dnl
define(`_LAYOUT_SUBDIVIDE_UP', `dnl
define(`_LAYOUT_X_$3', _LAYOUT_X_$1)dnl
define(`_LAYOUT_Y_$3', eval(_LAYOUT_Y_$1 + _LAYOUT_HEIGHT_$1 - $2))dnl
define(`_LAYOUT_WIDTH_$3', _LAYOUT_WIDTH_$1)dnl
define(`_LAYOUT_HEIGHT_$3', $2)dnl
define(`_LAYOUT_X_$4', _LAYOUT_X_$1)dnl
define(`_LAYOUT_Y_$4', _LAYOUT_Y_$1)dnl
define(`_LAYOUT_WIDTH_$4', _LAYOUT_WIDTH_$1)dnl
define(`_LAYOUT_HEIGHT_$4', eval(_LAYOUT_HEIGHT_$1 - $2))dnl
')dnl
define(`_LAYOUT_SUBDIVIDE_DOWN', `LAYOUT_SUBDIVIDE(`$1', `UP', eval(LAYOUT_HEIGHT(`$1' - $2)), `$4', `$3')')dnl
dnl
dnl ### LAYOUT_PAD(name, padding, result) ###
dnl
define(`LAYOUT_PAD', `dnl
define(`_LAYOUT_X_$3', eval(_LAYOUT_X_$1 + $2))dnl
define(`_LAYOUT_Y_$3', eval(_LAYOUT_Y_$1 + $2))dnl
define(`_LAYOUT_WIDTH_$3', eval(_LAYOUT_WIDTH_$1 - (2 * ($2))))dnl
define(`_LAYOUT_HEIGHT_$3', eval(_LAYOUT_HEIGHT_$1 - (2 * ($2))))dnl
')dnl
dnl
dnl ### Predefined Layouts ###
dnl
define(`_LAYOUT_X_DISPLAY', `0')dnl
define(`_LAYOUT_Y_DISPLAY', `0')dnl
define(`_LAYOUT_WIDTH_DISPLAY', `80')dnl
define(`_LAYOUT_HEIGHT_DISPLAY', `80')dnl
define(`_LAYOUT_X_LARGE_DISPLAY', `0')dnl
define(`_LAYOUT_Y_LARGE_DISPLAY', `0')dnl
define(`_LAYOUT_WIDTH_LARGE_DISPLAY', `176')dnl
define(`_LAYOUT_HEIGHT_LARGE_DISPLAY', `176')