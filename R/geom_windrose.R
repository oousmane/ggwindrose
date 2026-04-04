# =============================================================================
#  geom_windrose.R
#  Wind rose geom and coordinate / scale / theme helpers.
#
#  Exported:
#    GeomWindrose          — ggproto Geom (extends GeomCol)
#    geom_windrose()       — main layer function
#    coord_windrose()      — coord_polar pre-configured for wind roses
#    scale_x_windrose()    — x scale with N / NE / E … compass labels
#    scale_fill_windrose() — sequential or manual fill scale for speed classes
#    windrose_calm_pct()   — compute calm % string for guide_windrose()
#    theme_windrose()      — opt-in convenience theme (no y-axis, bold labels)
# =============================================================================

# Suppress R CMD check NOTE for variables produced by StatWindrose
# and accessed via after_stat() inside aes().
utils::globalVariables("speed_class")

# --- GeomWindrose ggproto -----------------------------------------------------

#' @title Geom ggproto object for wind roses
#' @description
#' The `Geom` ggproto class underlying [ggwindrose::geom_windrose()]. Extends
#' `GeomCol` with wind-rose defaults (no sector borders).
#' Not intended for direct use.
#' @format NULL
#' @usage NULL
#' @export
GeomWindrose <- ggplot2::ggproto(
  "GeomWindrose",
  ggplot2::GeomCol,

  # No sector borders by default — cleaner look in polar coordinates
  default_aes = utils::modifyList(
    ggplot2::GeomCol$default_aes,
    ggplot2::aes(colour = NA, linewidth = 0.2)
  )
)


# --- geom_windrose ------------------------------------------------------------

#' Wind rose layer
#'
#' Draws a wind rose by binning wind direction (`x`) and speed (`y`) into
#' stacked frequency bars. Calm winds (speed \eqn{\le} `calm_threshold`)
#' are excluded from the bars but counted in the frequency denominator.
#'
#' No theme is applied. Add [ggwindrose::theme_windrose()] or any `+ theme_*()`.
#'
#' @param mapping    Set of aesthetic mappings. At minimum:
#'   `aes(x = wdir, y = wspd)`. `fill` defaults to
#'   `after_stat(speed_class)` unless overridden.
#' @param data       A data frame. `NULL` inherits from `ggplot()`.
#' @param position   Position adjustment. Default `"stack"`.
#' @param n_dir      Number of direction sectors. Default `16` (22.5°).
#'   Use `8` for 45° sectors.
#' @param speed_breaks Numeric vector of speed bin edges, or `NULL` for the
#'   default meteorological progression: `c(0.5, 1, 2, 4, 6, 8, 10, …, Inf)`.
#'   The last element may be `Inf` for an open-ended bin.
#' @param speed_labels Character vector of bin labels, length
#'   `length(speed_breaks) - 1`. Auto-generated when `NULL`.
#' @param calm_threshold Observations with speed \eqn{\le} this value are
#'   treated as calm. Default `0.5`.
#' @param na.rm      Drop `NA` values silently? Default `FALSE`.
#' @param show.legend Logical; `NA` includes in legend if mapped.
#' @param inherit.aes Inherit aesthetics from `ggplot()`? Default `TRUE`.
#' @param ...        Extra parameters passed to `GeomWindrose` or
#'   `StatWindrose`.
#'
#' @return A `ggplot2` layer.
#'
#' @seealso [ggwindrose::stat_windrose()], [ggwindrose::coord_windrose()], [ggwindrose::scale_x_windrose()],
#'   [ggwindrose::scale_fill_windrose()], [ggwindrose::guide_windrose()], [ggwindrose::windrose_calm_pct()],
#'   [ggwindrose::theme_windrose()]
#'
#' @examples
#' library(ggplot2)
#' set.seed(42)
#' df <- data.frame(
#'   wdir = sample(0:359, 500, replace = TRUE),
#'   wspd = c(rep(0, 30), rexp(470, 0.2))
#' )
#'
#' # Basic wind rose — 16 sectors, default speed breaks
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose(
#'     name  = "Speed (m/s)",
#'     guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
#'   )
#'
#' # 8 sectors with a base theme
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose(n_dir = 8) +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose(
#'     name  = "Speed (m/s)",
#'     guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
#'   ) +
#'   theme_minimal() +
#'   theme_windrose()
#'
#' # Faceted by season (each panel has its own calm %)
#' df$season <- sample(c("DJF", "MAM", "JJA", "SON"), 500, replace = TRUE)
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose() +
#'   facet_wrap(~season) +
#'   theme_minimal() +
#'   theme_windrose()
#'
#' @export
geom_windrose <- function(mapping        = NULL,
                          data           = NULL,
                          position       = "stack",
                          ...,
                          n_dir          = 16,
                          speed_breaks   = NULL,
                          speed_labels   = NULL,
                          calm_threshold = 0.5,
                          na.rm          = FALSE,
                          show.legend    = NA,
                          inherit.aes    = TRUE) {

  # Auto-inject fill = after_stat(speed_class) when not overridden by the user
  fill_default <- ggplot2::aes(fill = ggplot2::after_stat(speed_class))
  mapping <- if (is.null(mapping)) {
    fill_default
  } else if (!"fill" %in% names(mapping)) {
    utils::modifyList(mapping, fill_default)
  } else {
    mapping
  }

  ggplot2::layer(
    geom        = GeomWindrose,
    stat        = StatWindrose,
    data        = data,
    mapping     = mapping,
    position    = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params      = list(
      n_dir          = n_dir,
      speed_breaks   = speed_breaks,
      speed_labels   = speed_labels,
      calm_threshold = calm_threshold,
      width          = 360 / n_dir,   # bars fill the full sector width
      na.rm          = na.rm,
      ...
    )
  )
}


# --- Coordinate helper --------------------------------------------------------

#' Polar coordinate system for wind roses
#'
#' Wraps [ggplot2::coord_polar()] with the following defaults:
#' - `theta = "x"`: wind direction on the angular axis
#' - `start = 0`: North (x = 0°) at 12 o'clock
#' - `direction = 1`: clockwise (meteorological convention)
#'
#' | Degrees | Compass | Position |
#' |---------|---------|----------|
#' | 0 / 360 | N | 12 o'clock |
#' | 90 | E | 3 o'clock |
#' | 180 | S | 6 o'clock |
#' | 270 | W | 9 o'clock |
#'
#' @param ... Additional arguments passed to [ggplot2::coord_polar()].
#'
#' @return A `CoordPolar` object.
#'
#' @examples
#' # coord_windrose()
#'
#' @export
coord_windrose <- function(...) {
  ggplot2::coord_polar(
    theta     = "x",
    start     = 0,      # 0° (North) at 12 o'clock
    direction = 1,      # clockwise = meteorological convention
    clip      = "off",  # prevent outer bars from being clipped
    ...
  )
}


# --- x scale helper -----------------------------------------------------------

#' Compass-point x scale for wind roses
#'
#' Sets x-axis breaks and labels to standard compass points, with limits
#' fixed to \[0, 360\] so the rose forms a complete circle.
#'
#' @param compass `character(1)`. Compass resolution:
#'   - `"8pt"` (default): N, NE, E, SE, S, SW, W, NW (45° spacing)
#'   - `"4pt"`: N, E, S, W (90° spacing)
#'   - `"16pt"`: N, NNE, NE, ENE, … (22.5° spacing)
#' @param ... Additional arguments passed to [ggplot2::scale_x_continuous()].
#'
#' @return A `ScaleContinuous` object.
#'
#' @examples
#' # scale_x_windrose()        # 8-point compass (default)
#' # scale_x_windrose("4pt")   # 4-point compass
#' # scale_x_windrose("16pt")  # 16-point compass
#'
#' @export
scale_x_windrose <- function(compass = c("8pt", "4pt", "16pt"), ...) {
  compass <- match.arg(compass)

  pts <- switch(
    compass,
    "4pt"  = list(
      breaks = c(0, 90, 180, 270),
      labels = c("N", "E", "S", "W")
    ),
    "8pt"  = list(
      breaks = c(0, 45, 90, 135, 180, 225, 270, 315),
      labels = c("N", "NE", "E", "SE", "S", "SW", "W", "NW")
    ),
    "16pt" = list(
      breaks = seq(0, 337.5, by = 22.5),
      labels = c("N",   "NNE", "NE",  "ENE",
                 "E",   "ESE", "SE",  "SSE",
                 "S",   "SSW", "SW",  "WSW",
                 "W",   "WNW", "NW",  "NNW")
    )
  )

  ggplot2::scale_x_continuous(
    breaks = pts$breaks,
    labels = pts$labels,
    limits = c(0, 360),
    expand = c(0, 0),
    ...
  )
}


# --- y scale helper -----------------------------------------------------------

#' Radial (frequency) scale for wind roses
#'
#' Sets the lower limit of the radial axis to 0, preventing the negative
#' values that appear by default when ggplot2 expands the scale.
#'
#' Call after [ggwindrose::coord_windrose()] to ensure the radius starts at the centre.
#'
#' @param ... Additional arguments passed to [ggplot2::scale_y_continuous()].
#'
#' @return A `ScaleContinuous` object.
#'
#' @examples
#' # scale_y_windrose()
#'
#' @export
scale_y_windrose <- function(...) {
  ggplot2::scale_y_continuous(limits = c(0, NA), expand = c(0, 0.01), ...)
}


# --- fill scale helper --------------------------------------------------------

#' Fill scale for wind speed classes
#'
#' Provides either a named ColorBrewer palette ([ggplot2::scale_fill_brewer()])
#' or a fully manual colour vector ([ggplot2::scale_fill_manual()]).
#' Use the `guide` argument with [ggwindrose::guide_windrose()] to add a calm-% footer
#' below the legend.
#'
#' @param palette `character(1)`. ColorBrewer palette. Default `"YlOrRd"`.
#'   Ignored when `colors` is not `NULL`.
#' @param colors  Character vector of hex colours for a manual scale.
#'   When `NULL` (default), `palette` is used.
#' @param name    Legend title. Default `"Speed"`.
#' @param guide   Guide object. Default [ggwindrose::guide_windrose()], which
#'   automatically extracts and displays the calm-% footer.
#' @param ...     Extra arguments passed to the underlying scale function.
#'
#' @return A `Scale` object.
#'
#' @examples
#' # ColorBrewer palette
#' # scale_fill_windrose()
#'
#' # With calm-% footer in the legend
#' # scale_fill_windrose(
#' #   guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
#' # )
#'
#' # Manual colours
#' # scale_fill_windrose(
#' #   colors = c("#ffffcc", "#fed976", "#fd8d3c", "#e31a1c")
#' # )
#'
#' @export
scale_fill_windrose <- function(palette = "YlOrRd",
                                colors  = NULL,
                                name    = "Speed",
                                guide   = NULL,
                                ...) {
  # Default to guide_windrose() so calm % is shown automatically.
  # NULL here avoids a cross-file forward reference at load time.
  if (is.null(guide)) guide <- guide_windrose()

  if (!is.null(colors)) {
    ggplot2::scale_fill_manual(values = colors, name = name, guide = guide, ...)
  } else {
    ggplot2::scale_fill_brewer(
      palette   = palette,
      direction = 1,
      name      = name,
      guide     = guide,
      ...
    )
  }
}


# --- Calm percentage helper ---------------------------------------------------

#' Compute a calm-wind label for use in guide_windrose()
#'
#' Returns a formatted string (e.g. `"Calm: 6.0%"`) to pass as `calm_text`
#' in [ggwindrose::guide_windrose()].
#'
#' @param wspd      Numeric vector of wind speeds.
#' @param threshold Observations with speed \eqn{\le} `threshold` are
#'   considered calm. Default `0.5`.
#' @param digits    Number of decimal places. Default `1`.
#' @param label     Label prefix. Default `"Calm: "`.
#'
#' @return A `character(1)` string, e.g. `"Calm: 6.0%"`.
#'
#' @examples
#' x <- c(0, 0, 0.3, 1.2, 3.4, 5.6)
#' windrose_calm_pct(x)                   # "Calm: 50.0%"
#' windrose_calm_pct(x, threshold = 1.0)  # includes 0.3 in calm
#' windrose_calm_pct(x, label = "Calme: ")
#'
#' @export
windrose_calm_pct <- function(wspd,
                              threshold = 0.5,
                              digits    = 1,
                              label     = "Calm: ") {
  if (!is.numeric(wspd))
    stop("`wspd` must be a numeric vector.", call. = FALSE)
  pct <- mean(wspd <= threshold, na.rm = TRUE) * 100
  sprintf(paste0(label, "%.", digits, "f%%"), pct)
}


# --- Theme helper -------------------------------------------------------------

#' Minimal theme adjustments for wind rose plots
#'
#' Returns a [ggplot2::theme()] object that:
#' - removes axis titles and y-axis text / ticks
#' - makes compass labels bold
#'
#' Add with `+ theme_windrose()`. No theme is applied by default inside
#' any `ggwindrose` function.
#'
#' @return A `theme` object.
#'
#' @examples
#' library(ggplot2)
#' set.seed(1)
#' df <- data.frame(wdir = sample(0:359, 300, replace = TRUE),
#'                  wspd = rexp(300, 0.2))
#'
#' # theme_windrose() alone
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose() +
#'   theme_windrose()
#'
#' # Combined with a base theme (order matters: base first, then windrose)
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose() +
#'   theme_minimal() +
#'   theme_windrose()
#'
#' @export
theme_windrose <- function() {
  ggplot2::theme(
    axis.title        = ggplot2::element_blank(),
    axis.text.y       = ggplot2::element_blank(),
    axis.ticks.y      = ggplot2::element_blank(),
    axis.text.x       = ggplot2::element_text(vjust = 1, hjust = 1, face = "bold"),
    panel.grid.minor  = ggplot2::element_blank(),
    panel.border      = ggplot2::element_blank()
  )
}
