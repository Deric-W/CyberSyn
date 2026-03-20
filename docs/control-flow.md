# Control flow

Utilities for expressing common control flow constructs.

## Macros

### `INVERSE_COND(condition)`

Expands to the inverse of `condition`.

Supports all conditions except of `strictEqual`.

#### Arguments

- `condition`: condition from a `jump` instruction to invert

### `IF(a, condition, b, body, [else])`

Execute `body` if the expression `a condition b` evaluates to true,
else execute `else`.

`body` and `else` will be executed in an additional scope.

#### Arguments

- `a`: first value in the condition
- `condition`: condition to use in the `jump` instruction
- `b`: second value in the condition
- `body`: code to execute if the condition holds true
- `else`: optional code to execute if the condition does not hold true

#### Pseudocode

```
if (a condition b) {
    body
} else {
    else
}
```

### `DOWHILELOOP(a, condition, b, body)`

Execute `body` until `a condition b` evaluates to false.

`body` will be executed in an additional scope.

#### Arguments

- `a`: first value in the condition
- `condition`: condition to use in the `jump` instruction
- `b`: second value in the condition
- `body`: code to execute until the condition does not hold true

#### Pseudocode

```
do {
    body
} while (iter condition value)
```

### `WHILELOOP(a, condition, b, body, [init])`

Execute `body` while `a condition b` evaluates to true.

`body` will be executed in an additional scope.

#### Arguments

- `a`: first value in the condition
- `condition`: condition to use in the `jump` instruction
- `b`: second value in the condition
- `body`: code to execute while the condition holds true

#### Pseudocode

```
if (a condition b) {
    init
    do {
        body
    } while (a condition b)
}
```

### `FORLOOP(iter, start, end, delta, body)`

Execute `body` for every value greater than or equal to `start` and less than
`end`, incrementing it by `delta` every iteration.

`body` will be executed in an additional scope.

#### Arguments

- `iter`: name of a variable which will hold the value during each iteration
- `start`: initial iteration value
- `end`: iteration value which will terminate the loop when reached
- `delta`: amount the iteration value is incremented every iteration
- `body`: code to execute for every iteration value

#### Pseudocode

```
if (start < end) {
    Number iter = start
    do {
        body
        iter += delta
    } while(iter < end)
}
```

### `LINKLOOP(index, iter, body)`

Execute `body` for every linked building.

`body` will be executed in an additional scope.

#### Arguments

- `index`: name of a variable which will store the index of the linked building during each iteration
- `iter`: name of a variable which will store the linked building during each iteration
- `body`: code to execute for every linked building

#### Pseudocode

```
FORLOOP(
    index,
    0,
    @links,
    1,
    Building iter = getLink(index)
    body
)
```
