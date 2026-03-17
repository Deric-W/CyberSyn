dnl
dnl ### Helper macros ###
dnl
define(`_forloop', `pushdef(`$1', `$2')__forloop($@)popdef(`$1')')dnl
define(`__forloop', `ifelse($1, `$3', `', `$4`'define(`$1', incr($1))$0($@)')')dnl
define(`_add1', `define(`$1', incr($1))')dnl
dnl
dnl ### global Variables ###
dnl
ifdef(`DEFINITIONS_IN_SCOPE', `', `define(`DEFINITIONS_IN_SCOPE', 0)')dnl
ifdef(`TOTAL_DEFINITIONS', `', `define(`TOTAL_DEFINITIONS', 0)')dnl
ifdef(`SCOPE_DEPTH', `', `define(`SCOPE_DEPTH', 0)')dnl
ifdef(`LABEL_COUNT', `', `define(`LABEL_COUNT', 0)')dnl
dnl
dnl ### BEGIN_SCOPE ###
dnl
define(`BEGIN_SCOPE', `dnl
pushdef(`DEFINITIONS_IN_SCOPE', 0)dnl
pushdef(`SCOPE_SHADOWED_COUNT', 0)dnl
')dnl
dnl
dnl ### END_SCOPE
dnl
define(`END_SCOPE',`dnl
define(`TOTAL_DEFINITIONS', eval(TOTAL_DEFINITIONS-DEFINITIONS_IN_SCOPE))dnl
_forloop(_, 0, DEFINITIONS_IN_SCOPE, `dnl
undefine(defn(`SCOPE_IDENTIFIERS'))dnl
popdef(`SCOPE_IDENTIFIERS')dnl
')dnl
_forloop(_, 0, SCOPE_SHADOWED_COUNT, `dnl
define(defn(`SCOPE_SHADOWED_IDENTIFIERS'), defn(`SCOPE_SHADOWED_VALUES'))dnl
popdef(`SCOPE_SHADOWED_IDENTIFIERS')dnl
popdef(`SCOPE_SHADOWED_VALUES')dnl
')dnl
popdef(`DEFINITIONS_IN_SCOPE')dnl
popdef(`SCOPE_SHADOWED_COUNT')dnl
')dnl
dnl
dnl ### SCOPED_DEFINE(name, definition)
dnl
define(`SCOPED_DEFINE',`dnl
ifdef(`$1', `dnl
pushdef(`SCOPE_SHADOWED_IDENTIFIERS', `$1')dnl
pushdef(`SCOPE_SHADOWED_VALUES', defn(`$1'))dnl
_add1(`SCOPE_SHADOWED_COUNT')dnl
')dnl
define(`$1', `$2')dnl
_add1(`TOTAL_DEFINITIONS')dnl
_add1(`DEFINITIONS_IN_SCOPE')dnl
pushdef(`SCOPE_IDENTIFIERS', `$1')dnl
')dnl
dnl
dnl ### IDENTIFIER(name)
dnl
define(`IDENTIFIER', `SCOPED_DEFINE(`$1', format(`identifier%s', TOTAL_DEFINITIONS))')dnl
dnl
dnl ### LABEL(name)
dnl
define(`LABEL', `dnl
SCOPED_DEFINE(`$1', format(`label%s', LABEL_COUNT))dnl
_add1(`LABEL_COUNT')dnl
')