# Remote Connect

To communicate across long distances multiple processors can aquire a reference
to a shared memory cell (or bank) via a unit.
This reference can then be used to read and write, even when the referenced building
is actually out of range of the processor.

## Macros

### `remoteConnectTryAquireReference(flag, x, y, referenceVariable, unitInvalidLabel, buildingInvalidLabel)`

Aquire a reference to a shared memory cell (or bank), using the currently bound
unit to acquire a reference of the block at the specified coordinates.

Should the unit become invalid or the building the specified coordinates either
not exist or not be a memory cell (or bank) control will be returned to one of
the specified labels.

#### Arguments

- `flag`: Flag of the currently bound unit
- `x`, `y`: Coordinates of the shared memory cell or bank
- `referenceVariable`: Variable in which the acquired reference shall be stored
- `unitInvalidLabel`: Label to which control will be transferred should the unit become invalid
- `buildingInvalidLabel`: Label to which control will be transferred should the building be invalid

#### Pseudocode

```
while (true) {
    jumpIfFlaggedUnitIsInvalid(@unit, flag, unitInvalidLabel)
    unit.getBlock(x, y out _, out Building referenceVariable, out _)
    if (referenceVariable.type === @memory-cell || referenceVariable.type === @memory-bank) {
        break
    }
    if (unit.within(x, y, 7)) {
        goto buildingInvalidLabel
    }
    unit.approach(x, y, 7)
}
exit:
```


### `remoteConnect(type, flag, x, y, setup, loop, referenceVariable)`

Generate a program which will handle acquiring a reference to a shared
memory cell (or bank) and renew it should the reference become invalid.

#### Arguments

- `type`: Type of units to bind
- `flag`: Flag of units to bind
- `x`, `y`: Coordinates of the shared memory cell or bank
- `setup`: Code to be executed once at startup
- `loop`: Code to be executed while the reference is valid
- `referenceVariable`: Variable in which the acquired reference shall be stored

#### Pseudocode

```
setup()

while (true) {
    UnitErrorContinue:
    Unit @unit = bind(type)
    BuildingError:
    remoteConnectTryAquireReference(flag, x, y, out referenceVariable, UnitError, BuildingError)
    UnitError:
    unbind()
    
    while (referenceVariable !== null && !referenceVariable.dead) {
        loop()
    }
}

UnitError:
unbind()
goto UnitErrorContinue
```

## Examples

Write the status of a connected switch to memory:

```m4
include(`communication/remote-connect.m4')dnl
remoteConnect(
    @flare,
    0,
    63,
    131,
    `set input switch1',
`sensor status input @enabled
write status reference 0',
    reference)
```

Read it from memory on a different processor and apply it to a connected switch:

```m4
include(`communication/remote-connect.m4')dnl
remoteConnect(
    @flare,
    0,
    63,
    131,
    `set input switch1',
`read status reference 0
control enabled input status _ _ _',
    reference)
```
