# Workers

Framework for processors ("workers") which receive tasks from a controlling processor.

The framework handles processors not being ready, for example by being part of
a schematic which constructed the controlling processor first.
Restarting or breaking the processors during operation is not being handled by
the framework.

## Macros

### `WORKER_ARG(N)`

Expands to the variable holding argument number `N` of a worker.

The variables are the same for every worker.

### `workerInit(args...)`

Prepares the current processor to act as a worker.

To allow receiving arguments they have to be initialized by passing them as `args`.

### `workerPollTask(taskVariable, pendingLabel)`

Check if a task has been assigned to this worker, jumping to `pendingLabel`
if this is not the case.

The task is stored in the variable whose name is passed as `taskVariable`,
with arguments usually being stored in [`WORKER_ARG(N)`](#worker_argn).

### `workerFinishTask()`

Mark this worker as having finished its task.

The results of a task are usually written to [`WORKER_ARG(N)`](#worker_argn)
before signaling its completion. 

### `workerSubmitTask(worker, task)`

Submit `task` to processor `worker`, initiating its processing. `task` may not
be `null`.

Arguments of the task are usually written to [`WORKER_ARG(N)`](#worker_argn)
before its submission.

Should the worker not be ready, for example by still processing a previous task
or not having called [`workerInit(args...)`](#workerinitargs) yet, the result of
this call is undefined.

### `workerPollReady(worker, pendingLabel)`

Check whether the processor `worker` is ready to accept new tasks, jumping to
`pendingLabel` if this is not the case.

The results of the task are usually stored in [`WORKER_ARG(N)`](#worker_argn).

This function supports being called with invalid building references,
treating them as not ready.

### `workerReset(worker)`

Reset the processor `worker`, canceling any task currently being processed.

Since resetting is similar to the processor being restarted the worker may not
be ready immediately and support it without additional cleanup being necessary.

The controlling processor should reset all workers supporting this operation on
startup to guard against running commands from a previous run if it was reset by
the user.

## Examples

Worker which adds and multiplies numbers:

```mlog
include(`communication/sync/workers.m4')dnl
dnl
workerInit(0, 1)

pollTask:
workerPollTask(task, pollTask)
jump addCommand strictEqual task 1
jump mulCommand strictEqual task 2
jump pollTask always

addCommand:
op add WORKER_ARG(0) WORKER_ARG(0) WORKER_ARG(1)
jump finishTask always

mulCommand:
op mul WORKER_ARG(0) WORKER_ARG(0) WORKER_ARG(1)

finishTask:
workerFinishTask()
jump pollTask always
```

Controlling processor calculating (42 + 24) * 8:

```mlog
include(`communication/sync/workers.m4')dnl
dnl
workerReset(processor1)
waitReady:
workerPollReady(processor1, waitReady)

write 42 processor1 "WORKER_ARG(0)"
write 24 processor1 "WORKER_ARG(1)"
workerSubmitTask(processor1, 1)
waitAdd:
workerPollReady(processor1, waitAdd)

write 8 processor1 "WORKER_ARG(1)"
workerSubmitTask(processor1, 2)
waitMul:
workerPollReady(processor1, waitMul)

read result processor1 "WORKER_ARG(0)"
stop
```
