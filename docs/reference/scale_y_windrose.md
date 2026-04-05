# Radial (frequency) scale for wind roses

Sets the lower limit of the radial axis to 0, preventing the negative
values that appear by default when ggplot2 expands the scale.

## Usage

``` r
scale_y_windrose(...)
```

## Arguments

- ...:

  Additional arguments passed to
  [`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html).

## Value

A `ScaleContinuous` object.

## Details

Call after
[`coord_windrose()`](https://oousmane.github.io/ggwindrose/reference/coord_windrose.md)
to ensure the radius starts at the centre.

## Examples

``` r
# scale_y_windrose()
```
