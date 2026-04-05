# Polar coordinate system for wind roses

Wraps
[`ggplot2::coord_polar()`](https://ggplot2.tidyverse.org/reference/coord_radial.html)
with the following defaults:

- `theta = "x"`: wind direction on the angular axis

- `start = 0`: North (x = 0°) at 12 o'clock

- `direction = 1`: clockwise (meteorological convention)

## Usage

``` r
coord_windrose(...)
```

## Arguments

- ...:

  Additional arguments passed to
  [`ggplot2::coord_polar()`](https://ggplot2.tidyverse.org/reference/coord_radial.html).

## Value

A `CoordPolar` object.

## Details

|         |         |            |
|---------|---------|------------|
| Degrees | Compass | Position   |
| 0 / 360 | N       | 12 o'clock |
| 90      | E       | 3 o'clock  |
| 180     | S       | 6 o'clock  |
| 270     | W       | 9 o'clock  |

## Examples

``` r
# coord_windrose()
```
