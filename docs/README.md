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

## Programs

### Power

Programs for dealing with power generation and monitoring.

[`power/SCRAM.m4`](./power/SCRAM.md)

## Libraries

[`scope.m4`](./scope.md)

[`units.m4`](./units.md)

### Algorithms

General-purpose algorithm implementations.

[`algorithms/memory.m4`](./algorithms/memory.md)

### Communication

Communication between processors.

[`communication/remote-connect.m4`](./communication/remote-connect.md)
