include(`scope.m4')dnl
include(`comptime.m4')dnl
dnl
dnl ### WORKER_ARG(N) ###
dnl
define(`WORKER_ARG', `_WORKERS_WORKER_ARG$1')dnl
dnl
dnl ### workerInit(args...) ###
dnl
define(`workerInit', `dnl
COMPTIME_FOREACH(`arg', `$@', `dnl
set WORKER_ARG(arg) null
')`'dnl
set _WORKERS_CURRENT_COMMAND "_WORKERS_WORKER_IDLE_CMD"`'dnl
')dnl
dnl
dnl ### workerPollTask(taskVariable, pendingLabel) ###
dnl
define(`workerPollTask', `dnl
set $1 _WORKERS_CURRENT_COMMAND
jump $2 strictEqual $1 "_WORKERS_WORKER_IDLE_CMD"`'dnl
')dnl
dnl
dnl ### workerFinishTask() ###
dnl
define(`workerFinishTask', `set _WORKERS_CURRENT_COMMAND "_WORKERS_WORKER_IDLE_CMD"')dnl
dnl
dnl ### workerSubmitTask(worker, task) ###
dnl
define(`workerSubmitTask', `dnl
COMPTIME_ASSERT(ifelse(`$2', `"_WORKERS_WORKER_IDLE_CMD"', 0, 1), `"_WORKERS_WORKER_IDLE_CMD" is a command reserved for internal use')dnl
COMPTIME_ASSERT(ifelse(`$2', `null', 0, 1), `null is a command reserved for internal use')dnl
write $2 $1 "_WORKERS_CURRENT_COMMAND"`'dnl
')dnl
dnl
dnl ### workerPollReady(worker, pendingLabel) ###
dnl
define(`workerPollReady', `BEGIN_SCOPE`'dnl
IDENTIFIER(`status')dnl
read status $1 "_WORKERS_CURRENT_COMMAND"
op strictEqual status status "_WORKERS_WORKER_IDLE_CMD"
jump $2 equal status false`'dnl
END_SCOPE')dnl
dnl
dnl ### workerReset(worker) ###
dnl
define(`workerReset', `dnl
control enabled $1 false
write null $1 "_WORKERS_CURRENT_COMMAND"
write 0 $1 "@counter"
control enabled $1 true`'dnl
')