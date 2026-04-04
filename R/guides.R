# =============================================================================
#  guide_windrose.R
#  GuideWindrose: extends GuideLegend to render a calm-% footer below the
#  legend boxes.
#
#  The calm percentage is extracted automatically from StatWindrose layer
#  data via process_layers() — no need to pass it manually.
#
#  Requires ggplot2 >= 3.5.0 (guide system rewritten using ggproto).
# =============================================================================

#' @title Guide ggproto object for wind rose legends
#' @description
#' The `Guide` ggproto class underlying [ggwindrose::guide_windrose()].
#' Extends `GuideLegend` to render a calm-wind percentage footer.
#' Not intended for direct use.
#' @importFrom grid textGrob unit gpar
#' @importFrom gtable gtable_add_rows gtable_add_grob
#' @format NULL
#' @usage NULL
#' @export
GuideWindrose <- ggplot2::ggproto(
  "GuideWindrose",
  ggplot2::GuideLegend,

  # Declare calm_text as a valid parameter alongside GuideLegend's own params
  params = c(
    ggplot2::GuideLegend$params,
    list(calm_text = NULL)
  ),

  # ---- Auto-extract calm_pct from StatWindrose layer data ------------------
  #
  # process_layers() is called AFTER stats are computed, so calm_pct
  # (a constant column added by StatWindrose$compute_panel) is available.
  # If calm_text was explicitly set by the user, it is left untouched.
  # ... absorbs extra arguments added in ggplot2 4.0 (e.g. theme).
  # Using ... makes GuideWindrose forward-compatible across ggplot2 versions.
  process_layers = function(self, params, layers, data, ...) {

    # Let GuideLegend do its own processing first, forwarding all arguments
    params <- ggplot2::ggproto_parent(ggplot2::GuideLegend, self)$process_layers(
      params = params,
      layers = layers,
      data   = data,
      ...
    )

    # Only auto-fill when calm_text was not explicitly provided
    if (is.null(params$calm_text)) {
      for (i in seq_along(layers)) {
        d <- data[[i]]
        if (!is.null(d) &&
            nrow(d) > 0 &&
            "calm_pct" %in% names(d) &&
            inherits(layers[[i]]$stat, "StatWindrose")) {
          pct              <- d$calm_pct[[1L]]
          params$calm_text <- sprintf("Calm: %.1f%%", pct)
          break
        }
      }
    }
    params
  },

  # ---- Append calm footer grob below the legend table ----------------------
  draw = function(self, theme, position = NULL, direction = NULL,
                  params = self$params) {

    gt <- ggplot2::ggproto_parent(ggplot2::GuideLegend, self)$draw(
      theme     = theme,
      position  = position,
      direction = direction,
      params    = params
    )

    calm_text <- params[["calm_text"]]
    if (!is.null(calm_text) && nzchar(trimws(calm_text))) {
      footer <- grid::textGrob(
        label = calm_text,
        x     = grid::unit(0.5, "npc"),
        y     = grid::unit(0.5, "npc"),
        just  = "center",
        gp    = grid::gpar(fontsize = 8.5, col = "grey35", fontface = "italic")
      )
      gt <- gtable::gtable_add_rows(gt, heights = grid::unit(1.8, "lines"))
      gt <- gtable::gtable_add_grob(
        gt,
        grobs = footer,
        t     = nrow(gt),
        l     = 1L,
        r     = ncol(gt),
        name  = "windrose-calm-footer"
      )
    }
    gt
  }
)


# --- Constructor --------------------------------------------------------------

#' Legend guide with automatic calm-wind footer
#'
#' Extends [ggplot2::guide_legend()] to render the calm-wind percentage
#' below the legend colour boxes.
#'
#' The calm percentage is extracted **automatically** from the
#' `StatWindrose` layer data — no need to compute or pass it manually.
#' Just use `guide_windrose()` with no arguments.
#'
#' You may still override the footer text via `calm_text` if needed
#' (e.g. for a translated label or a different threshold).
#'
#' Requires **ggplot2 >= 3.5.0**.
#'
#' @param calm_text `character(1)` or `NULL`. Footer text. When `NULL`
#'   (default), the calm percentage is extracted automatically from
#'   the `StatWindrose` layer data.
#' @param title `character(1)` or [ggplot2::waiver()]. Legend title.
#' @param ... Additional arguments forwarded to [ggplot2::guide_legend()].
#'
#' @return A `GuideWindrose` ggproto object.
#'
#' @seealso [ggwindrose::scale_fill_windrose()], [ggwindrose::windrose_calm_pct()]
#'
#' @examples
#' library(ggplot2)
#' set.seed(1)
#' df <- data.frame(wdir = sample(0:359, 300, replace = TRUE),
#'                  wspd = c(rep(0, 20), rexp(280, 0.2)))
#'
#' # Calm % added automatically — no df$wspd needed
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose(name = "Speed (m/s)") +
#'   theme_windrose()
#'
#' # Override the footer label (e.g. French)
#' ggplot(df, aes(x = wdir, y = wspd)) +
#'   geom_windrose() +
#'   coord_windrose() +
#'   scale_x_windrose() +
#'   scale_fill_windrose(
#'     name  = "Vitesse (m/s)",
#'     guide = guide_windrose(calm_text = windrose_calm_pct(df$wspd,
#'                                                          label = "Calme : "))
#'   ) +
#'   theme_windrose()
#'
#' @export
guide_windrose <- function(calm_text = NULL,
                           title     = ggplot2::waiver(),
                           ...) {

  if (utils::packageVersion("ggplot2") < "3.5.0")
    stop(
      "guide_windrose() requires ggplot2 >= 3.5.0.\n",
      "  Install the latest version: install.packages('ggplot2')",
      call. = FALSE
    )

  ggplot2::new_guide(
    calm_text     = calm_text,
    title         = title,
    available_aes = "any",
    ...,
    super         = GuideWindrose
  )
}
