# =============================================================================
#  ggwindrose-package.R
#  Package-level documentation and re-exports.
# =============================================================================

#' ggwindrose: Wind Rose Geom for 'ggplot2'
#'
#' @description
#' Extends 'ggplot2' with a wind rose geom that bins wind direction and speed
#' observations into a direction-by-speed frequency table using a custom
#' `Stat`/`Geom` pair. Coordinate, scale, and theme helpers are provided to
#' produce publication-ready wind roses following meteorological conventions
#' (North at 12 o'clock, clockwise rotation). A custom guide
#' ([ggwindrose::guide_windrose()]) renders the calm-wind percentage below the legend.
#'
#' ## Core functions
#'
#' | Function | Description |
#' |---|---|
#' | [ggwindrose::geom_windrose()] | Wind rose layer (main entry point) |
#' | [ggwindrose::stat_windrose()] | Underlying stat (direction × speed binning) |
#' | [ggwindrose::coord_windrose()] | Polar coordinates: North up, clockwise |
#' | [ggwindrose::scale_x_windrose()] | Compass-point x-axis labels |
#' | [ggwindrose::scale_fill_windrose()] | Speed-class fill scale |
#' | [ggwindrose::guide_windrose()] | Legend with calm-% footer |
#' | [ggwindrose::windrose_calm_pct()] | Format calm % as a string |
#' | [ggwindrose::theme_windrose()] | Opt-in minimal theme adjustments |
#'
#' ## Minimal example
#'
#' ```r
#' library(ggplot2)
#' set.seed(1)
#' df <- data.frame(wdir = sample(0:359, 500, replace = TRUE),
#'                  wspd = c(rep(0, 30), rexp(470, 0.2)))
#'
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose(
#'     name  = "Speed (m/s)",
#'     guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd))
#'   ) +
#'   theme_minimal() +
#'   theme_windrose()
#' ```
#'
#' @keywords internal
"_PACKAGE"

# Import the full ggplot2 namespace so all ggproto machinery is available
# without prefixing every call with ggplot2::.
#' @import ggplot2
#' @importFrom ggplot2 after_stat
#' @importFrom glue glue
#' @export
ggplot2::after_stat
