# Compass-point x scale for wind roses

Sets x-axis breaks and labels to standard compass points, with limits
fixed to \[0, 360\] so the rose forms a complete circle.

## Usage

``` r
scale_x_windrose(compass = c("8pt", "4pt", "16pt"), ...)
```

## Arguments

- compass:

  `character(1)`. Compass resolution:

  - `"8pt"` (default): N, NE, E, SE, S, SW, W, NW (45° spacing)

  - `"4pt"`: N, E, S, W (90° spacing)

  - `"16pt"`: N, NNE, NE, ENE, … (22.5° spacing)

- ...:

  Additional arguments passed to
  [`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html).

## Value

A `ScaleContinuous` object.

## Examples

``` r
# scale_x_windrose()        # 8-point compass (default)
# scale_x_windrose("4pt")   # 4-point compass
# scale_x_windrose("16pt")  # 16-point compass
```
