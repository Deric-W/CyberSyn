include(`scope.m4')dnl
include(`units.m4')dnl
dnl
dnl ### remoteConnectTryAquireReference(flag, x, y, referenceVariable, unitInvalidLabel, buildingInvalidLabel)
dnl
define(`remoteConnectTryAquireReference',`BEGIN_SCOPE`'dnl
LABEL(`remoteConnectLoop')dnl
LABEL(`remoteConnectControlExit')dnl
remoteConnectLoop:
jumpIfFlaggedUnitIsInvalid(`@unit', `$1', `$5')

ucontrol getBlock $2 $3 _ $4 _
sensor tmp $4 @type
jump remoteConnectControlExit strictEqual tmp @memory-cell
jump remoteConnectControlExit strictEqual tmp @memory-bank

ucontrol within $2 $3 7 tmp _
jump $6 equal tmp true

ucontrol approach $2 $3 7 _ _
jump remoteConnectLoop always _ _

remoteConnectControlExit:dnl
END_SCOPE')dnl
dnl
dnl ### remoteConnect(type, flag, x, y, loop, referenceVariable) ###
dnl
define(`remoteConnect',`BEGIN_SCOPE`'dnl
LABEL(`remoteConnectBindLoop')dnl
LABEL(`remoteConnectBuildingError')dnl
LABEL(`remoteConnectUserEventLoop')dnl
LABEL(`remoteConnectUnitError')dnl
remoteConnectBindLoop:
ubind $1
remoteConnectBuildingError:
remoteConnectTryAquireReference(`$2', `$3', `$4', `$6', remoteConnectUnitError, remoteConnectBuildingError)
ucontrol unbind _ _ _ _ _

remoteConnectUserEventLoop:
jump remoteConnectBindLoop strictEqual $6 null
sensor tmp $6 @dead
jump remoteConnectBindLoop equal tmp true

$5

jump remoteConnectUserEventLoop always _ _

remoteConnectUnitError:
ucontrol unbind _ _ _ _ _
jump remoteConnectBindLoop always _ _`'dnl
END_SCOPE')