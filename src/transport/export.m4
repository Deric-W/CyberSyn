include(`control-flow.m4')dnl
define(switch, switch1)dnl
define(itemSelect, sorter1)dnl
define(enableStatus, illuminator1)dnl
dnl
packcolor enabledColor 0 255 0 255
packcolor disabledColor 255 0 0 255

set lastEnabled null
set lastItem null
controlLoop:
sensor enabled switch @enabled
sensor item itemSelect @config
op strictEqual tmp1 enabled lastEnabled
op strictEqual tmp2 item lastItem
op land tmp1 tmp1 tmp2
jump controlLoop equal tmp1 true

LINKLOOP(index, building, `dnl
jump continue strictEqual building switch
jump continue strictEqual building itemSelect
jump continue strictEqual building enableStatus
control enabled building enabled
control config building item
continue:')

select tmp1 equal enabled true enabledColor disabledColor
control color enableStatus tmp1
control enabled enableStatus enabled
set lastEnabled enabled
set lastItem item
jump controlLoop always