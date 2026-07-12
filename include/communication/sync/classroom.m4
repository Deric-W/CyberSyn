include(`scope.m4')dnl
dnl
dnl ### classroomStudentRaise(teacher) ###
dnl
define(`classroomStudentRaise', `dnl
set _CLASSROOM_STUDENT_RAISED true
write @this $1 "_CLASSROOM_TEACHER_PENDING"`'dnl
')dnl
dnl
dnl ### classroomStudentPollCalledOn(teacher, pendingLabel) ###
dnl
define(`classroomStudentPollCalledOn', `BEGIN_SCOPE`'dnl
LABEL(`calledOn')dnl
jump calledOn strictEqual _CLASSROOM_STUDENT_RAISED false
write @this $1 "_CLASSROOM_TEACHER_PENDING"
jump $2 always
calledOn:`'dnl
END_SCOPE')dnl
dnl
dnl ### classroomTeacherInit() ###
dnl
define(`classroomTeacherInit', `set _CLASSROOM_TEACHER_PENDING null')dnl
dnl
dnl ### classroomTeacherPollRaised(studentVariable, pendingLabel) ###
dnl
define(`classroomTeacherPollRaised', `BEGIN_SCOPE`'dnl
IDENTIFIER(`hasRaised')dnl
set $1 _CLASSROOM_TEACHER_PENDING
jump $2 strictEqual $1 null
set _CLASSROOM_TEACHER_PENDING null
read hasRaised $1 "_CLASSROOM_STUDENT_RAISED"
jump $2 strictEqual hasRaised null
jump $2 strictEqual hasRaised false`'dnl
END_SCOPE')dnl
dnl
dnl ### classroomTeacherCallOn(student) ###
dnl
define(`classroomTeacherCallOn', `write false $1 "_CLASSROOM_STUDENT_RAISED"')