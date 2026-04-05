# =============================================================================
#  stat_windrose.R
#  StatWindrose ggproto object and stat_windrose() layer function.
#
#  Computes a direction x speed frequency table from raw wind observations.
#  Calm winds (speed <= calm_threshold) are excluded from the frequency bars
#  but kept in the denominator, so all frequencies sum to (100 - calm%).
#
#  Computed variables (accessible via after_stat()):
#    y           — frequency as % of all observations (excl. calm)
#    speed_class — ordered factor: speed bin label
#    calm_pct    — calm percentage (constant across the panel)
# =============================================================================

# --- Default speed breaks -----------------------------------------------------

#' Build default speed breaks from data range
#'
#' Uses a clean meteorological progression: 0.5, 1, 2, 4, 6, 8, 10, …
#' The last break is always open-ended (Inf).
#'
#' @param max_spd       Maximum observed wind speed.
#' @param calm_threshold Calm wind threshold (first break).
#' @noRd
.default_speed_breaks <- function(max_spd, calm_threshold = 0.5) {
  # Fixed progression — take those that fall within the data range
  progression <- c(1, 2, 4, 6, 8, 10, 12, 15, 20, 25, 30)
  interior    <- progression[progression > calm_threshold & progression < max_spd]
  c(calm_threshold, interior, Inf)
}

#' Auto-generate speed bin labels
#'
#' @param breaks Numeric vector of speed breaks (last may be Inf).
#' @noRd
.speed_labels <- function(breaks) {
  n <- length(breaks) - 1L
  vapply(seq_len(n), function(i) {
    lo <- breaks[i]
    hi <- breaks[i + 1L]
    if (is.infinite(hi))
      paste0("\u2265", lo)                    # ">=8"
    else
      paste0(lo, "\u2013", hi)               # "2-4"
  }, character(1L))
}


# --- Core computation ---------------------------------------------------------

#' Bin wind observations into a direction x speed frequency table
#'
#' @param wdir            Numeric vector of wind directions (degrees 0–360,
#'   0 = North, clockwise).
#' @param wspd            Numeric vector of wind speeds.
#' @param n_dir           Number of direction sectors.
#' @param speed_breaks    Numeric vector of speed bin edges or `NULL`.
#' @param speed_labels    Character vector of bin labels or `NULL`.
#' @param calm_threshold  Speeds <= this value are treated as calm.
#'
#' @return A data frame with columns x, y, speed_class, calm_pct.
#' @noRd
.compute_windrose <- function(wdir,
                              wspd,
                              n_dir          = 16,
                              speed_breaks   = NULL,
                              speed_labels   = NULL,
                              calm_threshold = 0.5) {

  # --- Basic validation -------------------------------------------------------
  if (length(wdir) != length(wspd))
    stop("wind direction and speed vectors must have the same length.",
         call. = FALSE)

  # --- Speed breaks -----------------------------------------------------------
  max_spd <- max(wspd, na.rm = TRUE)
  if (is.null(speed_breaks))
    speed_breaks <- .default_speed_breaks(max_spd, calm_threshold)

  # Replace Inf with max_spd + 1 for cut() compatibility, track if open-ended
  open_ended <- is.infinite(speed_breaks[length(speed_breaks)])
  speed_breaks_cut <- speed_breaks
  if (open_ended)
    speed_breaks_cut[length(speed_breaks_cut)] <- max(max_spd, speed_breaks[length(speed_breaks) - 1L]) + 1

  # --- Speed labels -----------------------------------------------------------
  n_bins <- length(speed_breaks) - 1L
  if (is.null(speed_labels))
    speed_labels <- .speed_labels(speed_breaks)

  if (length(speed_labels) != n_bins)
    stop(glue::glue(
      "`speed_labels` must have length {n_bins} (one fewer than `speed_breaks`)."
    ), call. = FALSE)

  # --- Calm observations ------------------------------------------------------
  n_total  <- sum(!is.na(wdir) & !is.na(wspd))
  is_calm  <- !is.na(wspd) & wspd <= calm_threshold
  calm_pct <- round(sum(is_calm, na.rm = TRUE) / n_total * 100, 1)

  # --- Valid (non-calm, non-NA) observations ----------------------------------
  valid <- !is.na(wdir) & !is.na(wspd) & wspd > calm_threshold
  wdir_v <- wdir[valid]
  wspd_v <- wspd[valid]

  # --- Direction bins (meteorological: 0 = North, clockwise) -----------------
  sector_width <- 360 / n_dir
  # Shift by half a sector so North (0°) is centred in its bin
  dir_shifted  <- (wdir_v + sector_width / 2) %% 360
  dir_idx      <- floor(dir_shifted / sector_width) + 1L   # 1..n_dir
  dir_mids     <- (seq_len(n_dir) - 1L) * sector_width     # 0, 22.5, ..., 337.5

  # --- Speed bins -------------------------------------------------------------
  spd_bin <- cut(
    wspd_v,
    breaks         = speed_breaks_cut,
    labels         = speed_labels,
    right          = FALSE,        # [lo, hi)
    include.lowest = TRUE          # include the leftmost point
  )

  # --- Frequency table --------------------------------------------------------
  dir_f <- factor(dir_idx, levels = seq_len(n_dir))
  spd_f <- factor(spd_bin, levels = speed_labels)

  tbl <- as.data.frame(table(dir_f = dir_f, spd_f = spd_f),
                       stringsAsFactors = FALSE)

  tbl$x           <- dir_mids[as.integer(tbl$dir_f)]
  tbl$y           <- tbl$Freq / n_total * 100           # % of ALL observations
  tbl$speed_class <- factor(tbl$spd_f, levels = speed_labels)
  tbl$calm_pct    <- calm_pct

  # Drop zero-frequency cells to keep the output lean
  tbl <- tbl[tbl$Freq > 0L, c("x", "y", "speed_class", "calm_pct"),
             drop = FALSE]
  rownames(tbl) <- NULL
  tbl
}


# --- StatWindrose ggproto -----------------------------------------------------

#' @title Stat ggproto object for wind roses
#' @description
#' The `Stat` ggproto class underlying [ggwindrose::stat_windrose()]. Bins
#' wind direction and speed into a direction-by-speed frequency table.
#' Not intended for direct use.
#' @format NULL
#' @usage NULL
#' @export
StatWindrose <- ggplot2::ggproto(
  "StatWindrose",
  ggplot2::Stat,

  # compute_panel (not compute_group) so frequencies are relative to the
  # full panel — each facet sums to its own 100% independently.
  compute_panel = function(data,
                           scales,
                           n_dir          = 16,
                           speed_breaks   = NULL,
                           speed_labels   = NULL,
                           calm_threshold = 0.5) {

    result <- .compute_windrose(
      wdir           = data$x,
      wspd           = data$y,
      n_dir          = n_dir,
      speed_breaks   = speed_breaks,
      speed_labels   = speed_labels,
      calm_threshold = calm_threshold
    )

    # group must be integer: position_stack does -data$group internally;
    # factor or character triggers "invalid argument to unary operator".
    result$group <- as.integer(result$speed_class)
    result
  },

  required_aes = c("x", "y")
)


# --- stat_windrose layer function ---------------------------------------------

#' Wind rose stat
#'
#' Bins wind direction (`x`) and speed (`y`) into a direction-by-speed
#' frequency table. Calm winds (speed \eqn{\le} `calm_threshold`) are
#' excluded from the bars but kept in the denominator.
#'
#' This stat is used internally by [ggwindrose::geom_windrose()]. Use [ggwindrose::stat_windrose()]
#' directly only when you need a non-default geom.
#'
#' @inheritParams geom_windrose
#' @param geom Geom to use. Default `"col"`.
#'
#' @section Computed variables:
#' \describe{
#'   \item{`after_stat(y)`}{Frequency as % of all observations (incl. calm).}
#'   \item{`after_stat(speed_class)`}{Ordered factor of speed bin labels.}
#'   \item{`after_stat(calm_pct)`}{Calm percentage, constant across the panel.}
#' }
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' # Access calm_pct via after_stat()
#' ggplot(wind, aes(x = wdir, y = wspd)) +
#'   stat_windrose(aes(fill = after_stat(speed_class)), width = 22.5) +
#'   coord_windrose() +
#'   scale_x_windrose()
#' }
#'
#' @export
stat_windrose <- function(mapping        = NULL,
                          data           = NULL,
                          geom           = "col",
                          position       = "stack",
                          ...,
                          n_dir          = 16,
                          speed_breaks   = NULL,
                          speed_labels   = NULL,
                          calm_threshold = 0.5,
                          na.rm          = FALSE,
                          show.legend    = NA,
                          inherit.aes    = TRUE) {

  ggplot2::layer(
    stat        = StatWindrose,
    geom        = geom,
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
      na.rm          = na.rm,
      ...
    )
  )
}
