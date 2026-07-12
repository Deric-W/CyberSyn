# Classroom

Framework for multiple processors ("students") which require exclusive attention
from a central processor ("teacher").

The framework handles teachers not being ready, for example by being part of
a schematic which constructed the student processor first.
Restarting or breaking the processors during an operation is not being handled
by the framework.

## Macros

### `classroomStudentRaise(teacher)`

"Raises the hand" of the current processor, notifying the `teacher` processor
to handle the request.

Note that there can only be one pending request per student processor
at a time, and the teacher may select requests arbitrarily.

### `classroomStudentPollCalledOn(teacher, pendingLabel)`

Check whether the `teacher` processor handled our request, jumping to
`pendingLabel` if this is not the case.

In the presence of other student processors this function has to be called
regularly, to "remind" the teacher processor of our request should it be
overwritten by another student processor.
The same is true if the teacher might not be ready to receive the request
at the time it was issued, or simply decided to not call
[`classroomTeacherCallOn`](#classroomteachercallonstudent).

### `classroomTeacherInit()`

Prepare this teacher to receive requests.

### `classroomTeacherPollRaised(studentVariable, pendingLabel)`

Check whether a student has "raised their hand", jumping to `pendingLabel`
if this is not the case.
A reference to the student processor which issued the request is stored in
the variable passed as `studentVariable`.

Calling this function again will generally not return the same student processor
(unless it reissued its request), making it important to hold onto the returned
reference to it during the handling of the request.

### `classroomTeacherCallOn(student)`

Notify a student processor that his request has been handled.

## Examples

Student requiring a unique id being assigned by the teacher:

```mlog
include(`communication/sync/classroom.m4')dnl
dnl
set studentId null
classroomStudentRaise(processor1)
callPending:
classroomStudentPollCalledOn(processor1, callPending)
stop
```

The corresponding teacher:

```mlog
include(`communication/sync/classroom.m4')dnl
dnl
classroomTeacherInit()
set nextId 0
callOnStudent:
classroomTeacherPollRaised(student, callOnStudent)
write nextId student "studentId"
classroomTeacherCallOn(student)
op add nextId nextId 1
jump callOnStudent always
```
