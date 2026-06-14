# Compile-time Macros

Macros for performing operations during compile time.

Unless statet otherwise, all macros defined in this file take
compile-time values (strings, number literals, ...) as arguments.

## Macros

### `COMPTIME_TODO([message])`

Mark a section of code as requiring completion.

This macro causes the m4 interpreter to display a message and exit with an
error, with the message being customizable via the (optional) first argument.

### `COMPTIME_ASSERT(expr, [message])`

Ensure a condition holds true.

This macro causes the m4 interpreter to display a message and exit with an
error should `eval(expr)` evaulate to zero, with the message being customizable
via the (optional) second argument.

### `COMPTIME_FORLOOP(iter, start, end, delta, body)`

Similar to [`FORLOOP`](./control-flow.md#forloopiter-start-end-delta-body),
but running at compile time and without additional scopes.

### `COMPTIME_FOREACH(iter, values, body)`

Expands to `body` for each value in the `values` list, with the
current element being available via the variable passed as `iter`.

To prevent unintentional macro expansions quote each value in the list,
for example like this: ``` ``a', `b', `c'' ```.

### `COMPTIME_MIN(a, b)`

Expands to the smallest number provided.

### `COMPTIME_MAX(a, b)`

Expands to the largest number provided.

### `COMPTIME_DIV_UP(a, b)`

Expands to the result of `eval(a / b)`, rounded up.

### `COMPTIME_ISQRT(x)`

Expands to the integer square root of `x`.

### `COMPTIME_ISQRT_UP(x)`

Expands to the integer square root of `x`, rounded up.
