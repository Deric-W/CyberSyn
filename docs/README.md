# Documentation

This directory contains additional documentation to increase the comprehensibility
of the code.

When adding new programs or libraries please add their documentation as separate
Markdown files and reference them from the following section using relative links.

## Code

To improve readability of the generated code any macros which generate code should
do so without any preceding or subsequent whitespace, such as spaces or newlines.

Any variables with the prefix `tmp` can be used by generated code at any time to
store temporary values and therefore become invalid after invoking any macro which
generates code.

When invoking macros to generate code keep in mind that they may finish with a label,
causing invalid jumps when not followed by any more instructions.
To prevent this end you programs in this case with an `end` instruction.

## Programs

### Power

Programs for dealing with power generation and monitoring.

[`power/SCRAM.m4`](./power/SCRAM.md)

## Libraries

[`scope.m4`](./scope.md)

[`control-flow.m4`](./control-flow.md)

[`units.m4`](./units.md)

### Algorithms

General-purpose algorithm implementations.

[`algorithms/memory.m4`](./algorithms/memory.md)

### Communication

Communication between processors.

[`communication/remote-connect.m4`](./communication/remote-connect.md)

### Graphics

Utilities for drawing on logic displays.

[`graphics/layout.m4`](./graphics/layout.md)
