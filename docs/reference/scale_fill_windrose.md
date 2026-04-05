# Fill scale for wind speed classes

Provides either a named ColorBrewer palette
([`ggplot2::scale_fill_brewer()`](https://ggplot2.tidyverse.org/reference/scale_brewer.html))
or a fully manual colour vector
([`ggplot2::scale_fill_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html)).
Use the `guide` argument with
[`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md)
to add a calm-% footer below the legend.

## Usage

``` r
scale_fill_windrose(
  palette = "YlOrRd",
  colors = NULL,
  name = "Speed",
  guide = NULL,
  ...
)
```

## Arguments

- palette:

  `character(1)`. ColorBrewer palette. Default `"YlOrRd"`. Ignored when
  `colors` is not `NULL`.

- colors:

  Character vector of hex colours for a manual scale. When `NULL`
  (default), `palette` is used.

- name:

  Legend title. Default `"Speed"`.

- guide:

  Guide object. Default
  [`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md),
  which automatically extracts and displays the calm-% footer.

- ...:

  Extra arguments passed to the underlying scale function.

## Value

A `Scale` object.

## Examples

``` r
# ColorBrewer palette
# scale_fill_windrose()

# With calm-% footer in the legend
# scale_fill_windrose(
#   guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
# )

# Manual colours
# scale_fill_windrose(
#   colors = c("#ffffcc", "#fed976", "#fd8d3c", "#e31a1c")
# )
```
