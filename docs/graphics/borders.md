# Borders

Collection of borders to be drawn around elements.

## Macros

### `BORDER_CONFIG(name, attribute, value)`

Configure an attribute with the spcified value on a border configuration with
the specified name.

All border configurations have to be configured with the `STYLE` attribute having
a value from the [Styles](#styles) section.

### `BORDER_INNER_LAYOUT(config, layout, innerLayout)`

Calculate the layout representing the interior of the border configuration `config`
when drawn in the specified `layout`, with the resulting layout having the name
passed as `innerLayout`.

### `drawBorder(config, layout)`

Draw the border configuration `config` in the specifed `layout`. 

## Styles

### `SIMPLE`

A simple `lineRect` enclosing the elements, with its color being determined by
the last `draw color` command.

#### Attributes

- `STROKE`: stroke of the `lineRect` to be drawn

## Examples

Drawing a square containing 4 additional squares:

```mlog
include(`graphics/layout.m4')dnl
include(`graphics/borders.m4')dnl
dnl
BORDER_CONFIG(`outerBorder', `STYLE', `SIMPLE')dnl
BORDER_CONFIG(`outerBorder', `STROKE', 2)dnl
BORDER_CONFIG(`innerBorder', `STYLE', `SIMPLE')dnl
BORDER_CONFIG(`innerBorder', `STROKE', 5)dnl
dnl
LAYOUT_PAD(`DISPLAY', 3, `outer')dnl
BORDER_INNER_LAYOUT(`outerBorder', `outer', `inner')dnl
LAYOUT_SUBDIVIDE(`inner', `LEFT', 15, `left', `mid')dnl
LAYOUT_SUBDIVIDE(`mid', `RIGHT', 15, `right', `mid1')dnl
LAYOUT_SUBDIVIDE(`mid1', `UP', 15, `up', `mid2')dnl
LAYOUT_SUBDIVIDE(`mid2', `DOWN', 15, `down', `rem')dnl
dnl
draw clear 0 0 0

draw color 255 255 255 255
drawBorder(`outerBorder', `outer')

draw color 255 0 0 125
drawBorder(`innerBorder', `left')

draw color 0 255 0 125
drawBorder(`innerBorder', `right')

draw color 0 0 255 125
drawBorder(`innerBorder', `up')

draw color 255 0 255 125
drawBorder(`innerBorder', `down')

draw color 255 255 0 125
drawBorder(`innerBorder', `rem')

drawflush display1
```
