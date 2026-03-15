include(`units.m4')dnl
define(`remoteConnectTryAquireReference',
remoteConnectLoop:
jumpIfFlaggedUnitIsInvalid(`@unit', `$1', `$5')dnl

ucontrol getBlock $2 $3 _ $4 _
sensor tmp $4 @type
jump remoteConnectControlExit strictEqual tmp @memory-cell
jump remoteConnectControlExit strictEqual tmp @memory-bank

ucontrol within $2 $3 7 tmp _
jump $6 equal tmp true

ucontrol approach $2 $3 7 _ _
jump remoteConnectLoop always _ _

remoteConnectControlExit:
)dnl
define(`remoteConnect',
$5

remoteConnectBindLoop:
ubind $1
remoteConnectBuildingError:
remoteConnectTryAquireReference(`$2', `$3', `$4', `$7', remoteConnectUnitError, remoteConnectBuildingError)dnl
ucontrol unbind _ _ _ _ _

remoteConnectUserEventLoop:
jump remoteConnectBindLoop strictEqual $7 null
sensor tmp $7 @dead
jump remoteConnectBindLoop equal tmp true

$6

jump remoteConnectUserEventLoop always _ _

remoteConnectUnitError:
ucontrol unbind _ _ _ _ _
jump remoteConnectBindLoop always _ _
)