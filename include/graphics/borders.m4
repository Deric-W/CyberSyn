include(`graphics/layout.m4')dnl
dnl
dnl ### BORDER_CONFIG(name, attribute, value) ###
dnl
define(`BORDER_CONFIG', `define(`_$0_$1_$2', `$3')')dnl
dnl
dnl ### BORDER_INNER_LAYOUT(config, layout, innerLayout) ###
dnl
define(`BORDER_INNER_LAYOUT', `indir(format(``_$0_%s'', _BORDER_CONFIG_$1_STYLE), $@)')dnl
dnl
dnl ### drawBorder(config, layout) ###
dnl
define(`drawBorder', `indir(format(``_$0_%s'', _BORDER_CONFIG_$1_STYLE), $@)')dnl
dnl
dnl ### SIMPLE style implementations ###
dnl
define(`_BORDER_INNER_LAYOUT_SIMPLE', `LAYOUT_PAD(`$2', _BORDER_CONFIG_$1_STROKE, `$3')')dnl
define(`_drawBorder_SIMPLE', `dnl
draw stroke _BORDER_CONFIG_$1_STROKE
draw lineRect LAYOUT_X(`$2') LAYOUT_Y(`$2') LAYOUT_WIDTH(`$2') LAYOUT_HEIGHT(`$2')`'dnl
')