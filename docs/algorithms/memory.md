# Memory

Primitives for working with memory.

## Macros

### `memset(cell, start, value, size)`

Inspired by C's [`memset`](https://en.cppreference.com/w/cpp/string/byte/memset.html)
functions, fills a range of memory with instances of `value`.

#### Arguments

- `cell`: Memory cell (or bank) which shall be filled
- `start`: index from which to start
- `value`: value to fill the range with
- `size`: Length of the range to be filled, starting from `start`

#### Pseudocode

```
Number current = start;
Number ending = start + size;
while (current < ending) {
    cell[current++] = value;
}
```

### `memcpy(dstCell, dst, srcCell, src, size)`

Inspired by C's [`memcpy`](https://en.cppreference.com/w/cpp/string/byte/memcpy.html)
function, copies `size` values from `srcCell` to `dstCell`, starting at `src` and
`dst` respectively.

The specified memory ranges may not overlap.

#### Arguments

- `dstCell`: Memory cell (or bank) into which data shall be copied
- `dst`: Index in `dstCell` where the copied data shall be placed
- `srcCell`: Memory cell (or bank) from which data shall be copied
- `src`: Index in `srcCell` from where the copied data shall be taken
- `size`: Amount of data copied in values 

#### Pseudocode

```
Number currentSrc = start
Number endingSrc = start + size
Number currentDst = dst
while (currentSrc < endingSrc) {
    dstCell[currentDst++] = srcCell[currentSrc++]
}
```

### `memmove(destCell, dst, srcCell, src, size)`

Variant of `memcpy` which handles overlapping memory ranges.

#### Arguments

- `dstCell`: Memory cell (or bank) into which data shall be copied
- `dst`: Index in `dstCell` where the copied data shall be placed
- `srcCell`: Memory cell (or bank) from which data shall be copied
- `src`: Index in `srcCell` from where the copied data shall be taken
- `size`: Amount of data copied in values

#### Pseudocode

```
Number currentSrc, endSrc, currentDst, delta
if (dst <= src) {
    currentSrc = src
    endingSrc = src + size
    currentDst = dst
    delta = 1
} else {
    currentSrc = src + size - 1
    endingSrc = src - 1
    currentDst = dst + size - 1
    delta = -1
}
while (currentSrc != endingSrc) {
    dstCell[currentDst] = srcCell[currentSrc]
    currentSrc += delta
    currentDst += delta
}
```

### `swap(cellX, x, cellY, y)`

Swaps the values at the specified indices in the specified cells.

#### Arguments

- `cellX`: Memory cell (or bank) containing the first value
- `x`: Index in `cellX` containing the first value
- `cellY`: Memory cell (or bank) containing the second value
- `y`: Index in `cellY` containing the second value

#### Pseudocode

```
Number tmp = cellX[x]
cellX[x] = cellY[y]
cellY[y] = tmp
```
