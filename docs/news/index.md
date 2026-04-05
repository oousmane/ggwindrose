# Changelog

## ggwindrose 0.1.0

Initial release.

### New functions

- [`geom_windrose()`](https://oousmane.github.io/ggwindrose/reference/geom_windrose.md)
  — stacked frequency bar layer for wind roses; supports `n_dir`,
  `speed_breaks`, `speed_labels`, and `calm_threshold`.
- [`stat_windrose()`](https://oousmane.github.io/ggwindrose/reference/stat_windrose.md)
  — underlying stat that bins wind direction × speed into a frequency
  table; exposes `after_stat(speed_class)` and `after_stat(calm_pct)`.
- [`coord_windrose()`](https://oousmane.github.io/ggwindrose/reference/coord_windrose.md)
  —
  [`coord_polar()`](https://ggplot2.tidyverse.org/reference/coord_radial.html)
  pre-configured for meteorological convention (North at top,
  clockwise).
- [`scale_x_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_x_windrose.md)
  — compass-point x-axis labels (4-, 8-, or 16-point).
- [`scale_y_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_y_windrose.md)
  — radial frequency axis starting at 0.
- [`scale_fill_windrose()`](https://oousmane.github.io/ggwindrose/reference/scale_fill_windrose.md)
  — ColorBrewer or manual fill scale for speed classes.
- [`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md)
  — legend guide with automatic calm-% footer.
- [`windrose_calm_pct()`](https://oousmane.github.io/ggwindrose/reference/windrose_calm_pct.md)
  — format calm-wind percentage as a label string.
- [`theme_windrose()`](https://oousmane.github.io/ggwindrose/reference/theme_windrose.md)
  — opt-in minimal theme (no axis clutter, bold compass labels).

### Data

- `wind` — hourly ERA5 reanalysis sample dataset with `wdir`, `wspd`,
  `year`, `month`, `day`, and `hour` columns.
