# ggwindrose: Wind Rose Geom for 'ggplot2'

Extends 'ggplot2' with a wind rose geom that bins wind direction and
speed observations into a direction-by-speed frequency table using a
custom `Stat`/`Geom` pair. Coordinate, scale, and theme helpers are
provided to produce publication-ready wind roses following
meteorological conventions (North at 12 o'clock, clockwise rotation). A
custom guide
([`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md))
renders the calm-wind percentage below the legend.

### Core functions

|  |  |
|----|----|
| Function | Description |
| [`geom_windrose()`](https://oousmane.github.io/ggwindrose/reference/geom_windrose.md) | Wind rose layer (main entry point) |
| [`stat_windrose()`](https://oousmane.github.io/ggwindrose/reference/stat_windrose.md) | Underlying stat (direction × speed binning) |
| [`coord_windrose()`](https://oousmane.github.io/ggwindrose/reference/coord_windrose.md) | Polar coordinates: North up, clockwise |
| [`scale_x_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_x_windrose.md) | Compass-point x-axis labels |
| [`scale_fill_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_fill_windrose.md) | Speed-class fill scale |
| [`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md) | Legend with calm-% footer |
| [`windrose_calm_pct()`](https://oousmane.github.io/ggwindrose/reference/windrose_calm_pct.md) | Format calm % as a string |
| [`theme_windrose()`](https://oousmane.github.io/ggwindrose/reference/theme_windrose.md) | Opt-in minimal theme adjustments |

### Minimal example

    library(ggplot2)
    set.seed(1)
    df <- data.frame(wdir = sample(0:359, 500, replace = TRUE),
                     wspd = c(rep(0, 30), rexp(470, 0.2)))

    ggplot(df, aes(x = wdir, y = wspd)) +
      geom_windrose() +
      coord_windrose() +
      scale_x_windrose() +
      scale_fill_windrose(
        name  = "Speed (m/s)",
        guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
      ) +
      theme_minimal() +
      theme_windrose()

## See also

Useful links:

- <https://github.com/oousmane/ggwindrose>

- Report bugs at <https://github.com/oousmane/ggwindrose/issues>

## Author

**Maintainer**: Ousmane Ouedraogo <oousmane@proton.me>
