# Assert

Implementation of runtime assertions.

These assertions only run if debug mode is enabled at compile time by
defining the `DEBUG` macro.

## Macros

### `IF_DEBUG(body, [else])`

Expands to `body` if debug mode is enabled, and `else` (defaults to nothing)
otherwise.

### `assert(a, condition, b, [message])`

Stops the processor if `a condition b` does not hold true, storing a message
(customizable by the optional `message` argument) in the variable `ASSERT_MSG`.
If debug mode is not enabled the call has no effect.

`condition a b` is evaluated by being passed directly to a `jump` instruction.

## Examples

```mlog
include(`assert.m4')dnl
dnl
assert(1, lessThan, 2, `impossible')
assert(2, lessThan, 1, `always happens in debug mode')
set MSG "debug mode has been disabled"
stop
```
