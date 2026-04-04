# ggwindrose 

<!-- badges: start -->
[![R-CMD-check](https://github.com/yourusername/ggwindrose/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yourusername/ggwindrose/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`ggwindrose` extends **ggplot2** with a wind rose geom that bins wind
direction and speed observations into a direction-by-speed frequency table
using a custom `Stat`/`Geom` pair.

## Features

- `geom_windrose()` — stacked frequency bars, fully compatible with `facet_wrap()`
- `coord_windrose()` — polar coordinates: **North at 12 o'clock, clockwise**
- `scale_x_windrose()` — compass labels (4, 8, or 16 points)
- `scale_y_windrose()` — radial frequency axis, starts at 0
- `scale_fill_windrose()` — sequential or manual colour scale
- `guide_windrose()` — legend with **automatic calm-% footer**
- `theme_windrose()` — opt-in minimal theme (no axis clutter)

## Installation

```r
# Development version from GitHub
# install.packages("pak")
pak::pak("oousmane/ggwindrose")
```

## Quick start

```r
library(ggplot2)
library(ggwindrose)

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
```

## Customisation

### Number of sectors

```r
# 16 sectors (default, 22.5°)
geom_windrose()

# 8 sectors (45°)
geom_windrose(n_dir = 8)
```

### Speed breaks

```r
# Default: automatic clean progression (0.5, 1, 2, 4, 6, 8, …)
geom_windrose()

# Custom breaks
geom_windrose(speed_breaks = c(0.5, 2, 4, 6, 8, Inf))
```

### Compass labels

```r
scale_x_windrose("4pt")    # N / E / S / W
scale_x_windrose("8pt")    # N / NE / E / SE / … (default)
scale_x_windrose("16pt")   # N / NNE / NE / ENE / …
```

### Colours

```r
# Default: YlOrRd ColorBrewer palette
scale_fill_windrose()

# Alternative Brewer palette
scale_fill_windrose(palette = "Blues")

# Manual colours
scale_fill_windrose(colors = hcl.colors(5, "Spectral", rev = TRUE))
```

### Calm percentage

The calm-% footer is added **automatically** to the legend — no extra code needed.
Calm winds (speed ≤ 0.5 m/s by default) are excluded from the bars but
counted in the frequency denominator.

```r
# Override the calm label (e.g. French)
scale_fill_windrose(
  guide = guide_windrose(
    calm_text = windrose_calm_pct(data$wspd, label = "Calme : ")
  )
)
```

### Facets

Each panel independently computes its own frequencies and calm percentage.

```r
data |>
  mutate(season = case_when(
    month %in% c(12, 1, 2) ~ "DJF",
    month %in% c(3, 4, 5)  ~ "MAM",
    month %in% c(6, 7, 8)  ~ "JJA",
    month %in% c(9, 10, 11) ~ "SON"
  )) |>
  ggplot(aes(x = wdir, y = wspd)) +
  geom_windrose() +
  coord_windrose() +
  scale_x_windrose() +
  scale_y_windrose() +
  scale_fill_windrose(name = "Speed (m/s)") +
  facet_wrap(~season) +
  theme_minimal() +
  theme_windrose()
```

## Design principles

- **No theme applied by default** — add `theme_minimal()`, `theme_bw()`,
  or any other theme and layer `theme_windrose()` on top.
- **Calm % is automatic** — `guide_windrose()` reads it from the stat data
  via `process_layers()`, so no manual computation is needed.
- **ggplot2 native** — works with `facet_wrap()`, `facet_grid()`,
  `ggsave()`, `patchwork`, and any other ggplot2 extension.

## Comparison with WRPLOT

| Feature | WRPLOT | ggwindrose |
|---|---|---|
| Stacking | non-stacked (each class from 0) | stacked (statistically correct) |
| Facets | manual export | `facet_wrap()` / `facet_grid()` |
| Customisation | GUI only | full ggplot2 grammar |
| Calm % | shown on plot | legend footer (automatic) |
| Export | PNG / EMF | `ggsave()` (any format) |

## Citation

```r
citation("ggwindrose")
```
