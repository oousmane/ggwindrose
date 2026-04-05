# Minimal theme adjustments for wind rose plots

Returns a
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
object that:

- removes axis titles and y-axis text / ticks

- makes compass labels bold

## Usage

``` r
theme_windrose()
```

## Value

A `theme` object.

## Details

Add with `+ theme_windrose()`. No theme is applied by default inside any
`ggwindrose` function.

## Examples

``` r
library(ggplot2)
set.seed(1)
df <- data.frame(wdir = sample(0:359, 300, replace = TRUE),
                 wspd = rexp(300, 0.2))

# theme_windrose() alone
ggplot(df, aes(x = wdir, y = wspd)) +
  geom_windrose() +
  coord_windrose() +
  scale_x_windrose() +
  scale_fill_windrose() +
  theme_windrose()
#> Warning: n too large, allowed maximum for palette YlOrRd is 9
#> Returning the palette you asked for with that many colors
#> Warning: Removed 7 rows containing missing values or values outside the scale range
#> (`geom_windrose()`).


# Combined with a base theme (order matters: base first, then windrose)
ggplot(df, aes(x = wdir, y = wspd)) +
  geom_windrose() +
  coord_windrose() +
  scale_x_windrose() +
  scale_fill_windrose() +
  theme_minimal() +
  theme_windrose()
#> Warning: n too large, allowed maximum for palette YlOrRd is 9
#> Returning the palette you asked for with that many colors
#> Warning: Removed 7 rows containing missing values or values outside the scale range
#> (`geom_windrose()`).

```
