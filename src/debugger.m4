include(`control-flow.m4')dnl
dnl
define(`output', `message1')dnl
dnl
printflush null
controlLoop:
LINKLOOP(`index', `processor', `dnl
LABEL(`skipProcessor')dnl
IDENTIFIER(`assertMsg')dnl
jump skipProcessor strictEqual processor output
read assertMsg processor "ASSERT_MSG"
jump skipProcessor strictEqual assertMsg null
print "[red]Link {0}:[] {1}\n"
format index
format assertMsg
skipProcessor:')
printflush output
jump controlLoop always