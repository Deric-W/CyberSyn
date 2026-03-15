# Units

Utilities for working with units.

## Macros

### `jumpIfUnitIsInvalid(unitVariable, failLabel)`

Check if a unit reference is invalid.

### Arguments

- `unitVariable`: Variable containing the reference to check
- `failLabel`: Location to jump to if the check fails

#### Pseudocode

```
if (unitVariable === null || unitVariable.dead || unitVariable.controlled == @ctrlPlayer || unitVariable.controlled == @ctrlCommand) {
    goto failLabel
}
```

### `jumpIfFlaggedUnitIsInvalid(unitVariable, flag, failLabel)`

Variant of `jumpIfUnitIsInvalid` which also checks the unit flag.

#### Arguments

- `unitVariable`: Variable containing the reference to check
- `flag`: Flag the unit is expected to have
- `failLabel`: Location to jump to if the check fails

#### Pseudocode

```
jumpIfUnitIsInvalid(unitVariable, failLabel)
if (unitVariable.flag != flag) {
    goto failLabel
}
```
