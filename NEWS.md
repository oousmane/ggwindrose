# ggwindrose 0.1.0

Initial release.

## New functions

- `geom_windrose()` — stacked frequency bar layer for wind roses; supports
  `n_dir`, `speed_breaks`, `speed_labels`, and `calm_threshold`.
- `stat_windrose()` — underlying stat that bins wind direction × speed into a
  frequency table; exposes `after_stat(speed_class)` and `after_stat(calm_pct)`.
- `coord_windrose()` — `coord_polar()` pre-configured for meteorological
  convention (North at top, clockwise).
- `scale_x_windrose()` — compass-point x-axis labels (4-, 8-, or 16-point).
- `scale_y_windrose()` — radial frequency axis starting at 0.
- `scale_fill_windrose()` — ColorBrewer or manual fill scale for speed classes.
- `guide_windrose()` — legend guide with automatic calm-% footer.
- `windrose_calm_pct()` — format calm-wind percentage as a label string.
- `theme_windrose()` — opt-in minimal theme (no axis clutter, bold compass labels).

## Data

- `wind` — hourly ERA5 reanalysis sample dataset with `wdir`, `wspd`, `year`,
  `month`, `day`, and `hour` columns.
