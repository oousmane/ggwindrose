# Package index

## Layer functions

Main user-facing layer, stat, and coordinate helpers

- [`geom_windrose()`](https://oousmane.github.io/ggwindrose/reference/geom_windrose.md)
  : Wind rose layer
- [`stat_windrose()`](https://oousmane.github.io/ggwindrose/reference/stat_windrose.md)
  : Wind rose stat
- [`coord_windrose()`](https://oousmane.github.io/ggwindrose/reference/coord_windrose.md)
  : Polar coordinate system for wind roses

## Scales & theme

- [`scale_x_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_x_windrose.md)
  : Compass-point x scale for wind roses
- [`scale_y_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_y_windrose.md)
  : Radial (frequency) scale for wind roses
- [`scale_fill_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_fill_windrose.md)
  : Fill scale for wind speed classes
- [`theme_windrose()`](https://oousmane.github.io/ggwindrose/reference/theme_windrose.md)
  : Minimal theme adjustments for wind rose plots

## Guide & utilities

- [`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md)
  : Legend guide with automatic calm-wind footer
- [`windrose_calm_pct()`](https://oousmane.github.io/ggwindrose/reference/windrose_calm_pct.md)
  : Compute a calm-wind label for use in guide_windrose()

## Data

- [`wind`](https://oousmane.github.io/ggwindrose/reference/wind.md) :
  Hourly wind observations

## Internals

ggproto objects, not for direct use

- [`GeomWindrose`](https://oousmane.github.io/ggwindrose/reference/GeomWindrose.md)
  : Geom ggproto object for wind roses
- [`StatWindrose`](https://oousmane.github.io/ggwindrose/reference/StatWindrose.md)
  : Stat ggproto object for wind roses
- [`GuideWindrose`](https://oousmane.github.io/ggwindrose/reference/GuideWindrose.md)
  : Guide ggproto object for wind rose legends
