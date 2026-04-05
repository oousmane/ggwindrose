# Wind rose layer

Draws a wind rose by binning wind direction (`x`) and speed (`y`) into
stacked frequency bars. Calm winds (speed \\\le\\ `calm_threshold`) are
excluded from the bars but counted in the frequency denominator.

## Usage

``` r
geom_windrose(
  mapping = NULL,
  data = NULL,
  position = "stack",
  ...,
  n_dir = 16,
  speed_breaks = NULL,
  speed_labels = NULL,
  calm_threshold = 0.5,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping:

  Set of aesthetic mappings. At minimum: `aes(x = wdir, y = wspd)`.
  `fill` defaults to `after_stat(speed_class)` unless overridden.

- data:

  A data frame. `NULL` inherits from
  [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

- position:

  Position adjustment. Default `"stack"`.

- ...:

  Extra parameters passed to `GeomWindrose` or `StatWindrose`.

- n_dir:

  Number of direction sectors. Default `16` (22.5°). Use `8` for 45°
  sectors.

- speed_breaks:

  Numeric vector of speed bin edges, or `NULL` for the default
  meteorological progression: `c(0.5, 1, 2, 4, 6, 8, 10, …, Inf)`. The
  last element may be `Inf` for an open-ended bin.

- speed_labels:

  Character vector of bin labels, length `length(speed_breaks) - 1`.
  Auto-generated when `NULL`.

- calm_threshold:

  Observations with speed \\\le\\ this value are treated as calm.
  Default `0.5`.

- na.rm:

  Drop `NA` values silently? Default `FALSE`.

- show.legend:

  Logical; `NA` includes in legend if mapped.

- inherit.aes:

  Inherit aesthetics from
  [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)?
  Default `TRUE`.

## Value

A `ggplot2` layer.

## Details

No theme is applied. Add
[`theme_windrose()`](https://oousmane.github.io/ggwindrose/reference/theme_windrose.md)
or any `+ theme_*()`.

## See also

[`stat_windrose()`](https://oousmane.github.io/ggwindrose/reference/stat_windrose.md),
[`coord_windrose()`](https://oousmane.github.io/ggwindrose/reference/coord_windrose.md),
[`scale_x_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_x_windrose.md),
[`scale_fill_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_fill_windrose.md),
[`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md),
[`windrose_calm_pct()`](https://oousmane.github.io/ggwindrose/reference/windrose_calm_pct.md),
[`theme_windrose()`](https://oousmane.github.io/ggwindrose/reference/theme_windrose.md)

## Examples

``` r
library(ggplot2)
set.seed(42)
df <- data.frame(
  wdir = sample(0:359, 500, replace = TRUE),
  wspd = c(rep(0, 30), rexp(470, 0.2))
)

# Basic wind rose — 16 sectors, default speed breaks
ggplot(df, aes(x = wdir, y = wspd)) +
  geom_windrose() +
  coord_windrose() +
  scale_x_windrose() +
  scale_fill_windrose(
    name  = "Speed (m/s)",
    guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
  )
#> Warning: n too large, allowed maximum for palette YlOrRd is 9
#> Returning the palette you asked for with that many colors
#> Warning: Removed 8 rows containing missing values or values outside the scale range
#> (`geom_windrose()`).


# 8 sectors with a base theme
ggplot(df, aes(x = wdir, y = wspd)) +
  geom_windrose(n_dir = 8) +
  coord_windrose() +
  scale_x_windrose() +
  scale_fill_windrose(
    name  = "Speed (m/s)",
    guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
  ) +
  theme_minimal() +
  theme_windrose()
#> Warning: n too large, allowed maximum for palette YlOrRd is 9
#> Returning the palette you asked for with that many colors
#> Warning: Removed 9 rows containing missing values or values outside the scale range
#> (`geom_windrose()`).


# Faceted by season (each panel has its own calm %)
df$season <- sample(c("DJF", "MAM", "JJA", "SON"), 500, replace = TRUE)
ggplot(df, aes(x = wdir, y = wspd)) +
  geom_windrose() +
  coord_windrose() +
  scale_x_windrose() +
  scale_fill_windrose() +
  facet_wrap(~season) +
  theme_minimal() +
  theme_windrose()
#> Warning: n too large, allowed maximum for palette YlOrRd is 9
#> Returning the palette you asked for with that many colors
#> Warning: Removed 17 rows containing missing values or values outside the scale range
#> (`geom_windrose()`).

```
