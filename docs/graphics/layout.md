# Layout

Tools for managing the layout of logic displays.

Layouts are rectangular boxes which control the placement of elements on a
logic display.

## Macros

### `LAYOUT_X(name)`

Evaluates to the X coordinate of the pixel und the bottom left corner of the
layout specified by `name`.

### `LAYOUT_Y(name)`

Evaluates to the Y coordinate of the pixel und the bottom left corner of the
layout specified by `name`.

### `LAYOUT_WIDTH(name)`

Evaluates to the width in pixels of the layout specified by `name`.

### `LAYOUT_HEIGHT(name)`

Evaluates to the height in pixels of the layout specified by `name`.

### `LAYOUT_SUBDIVIDE(name, direction, length, result, remaining)`

Subdivide the layout specified by `name`, splitting it along the specified `direction`.

The resulting sublayout if stored with the name passed as `result`, with its length
along the given direction (width or height) in pixels being equal to `length`.
The remaining space of `name` is also available as a layout with the name
passed as `remaining`.

The following directions are supported:
 - `LEFT`: split along the negative X-axis
 - `RIGHT`: split along the positive X-axis
 - `UP`: split along the positive Y-axis
 - `DOWN`: split along the negative Y-axis

### `LAYOUT_PAD(name, padding, result)`

Create a new layout with the name passed as `result` which represents the space
occupied by keeping the distance passed as `padding` in pixels from the interior
of the layout specified by `name`.

## Predefined Layouts

- `DISPLAY`: Layout of a [Logic Display](https://mindustry-unofficial.fandom.com/wiki/Logic_Display)

- `LARGE_DISPLAY`: Layout of a [Large Logic Display](https://mindustry-unofficial.fandom.com/wiki/Large_Logic_Display)

## Examples

For examples see the documentation of [`graphics/borders.m4`](./borders.md#examples).
