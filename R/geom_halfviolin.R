#' Half-Violin Plot
#'
#' This function creates a half-violin plot, which is a mirrored density plot.
#' It accepts all aesthetics of `geom_violin()` and an additional `panel` parameter
#' to control which side of the plot is displayed.
#'
#' @inheritParams ggplot2::geom_violin
#' @param panel Which half of the violin to draw. `"left"` / `"right"` clip along
#'   a vertical grouping axis (`aes(x = group, y = value)`). `"bottom"` / `"top"`
#'   clip along a horizontal grouping axis (`aes(x = value, y = group)`).
#'   `"left"` is treated as `"bottom"` and `"right"` as `"top"` when the layer
#'   is flipped, so the same `panel` values work without `coord_flip()`.
#' @param nudge Offset along the grouping axis (x when vertical, y when
#'   horizontal), applied after statistics. Default is `0`.
#' @import ggplot2
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_halfviolin(panel = "right") +
#'   theme_minimal()
#'
#' # Horizontal half-violin without coord_flip()
#' ggplot(mpg, aes(hwy, class)) +
#'   geom_halfviolin(panel = "top") +
#'   theme_minimal()
geom_halfviolin <- function(mapping = NULL, data = NULL, stat = "ydensity",
                            position = "dodge", trim = TRUE, scale = "area",
                            na.rm = FALSE, orientation = NA,
                            show.legend = NA, inherit.aes = TRUE, panel = "left",
                            nudge = 0, ...) {
  check_panel(panel)

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomHalfViolin,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      trim = trim,
      scale = scale,
      na.rm = na.rm,
      orientation = orientation,
      panel = panel,
      nudge = nudge,
      ...
    )
  )
}

#' GeomHalfViolin ggproto object
#'
#' The ggproto object used by \code{\link{geom_halfviolin}} to render half-violins.
#' @rdname geom_halfviolin
#' @format NULL
#' @usage NULL
#' @keywords internal
#' @export
GeomHalfViolin <- ggplot2::ggproto(
  "GeomHalfViolin", ggplot2::GeomViolin,
  extra_params = c("na.rm", "orientation", "lineend", "linejoin", "linemitre",
                   "panel", "nudge"),
  setup_data = function(self, data, params) {
    data <- ggplot2::ggproto_parent(ggplot2::GeomViolin, self)$setup_data(data, params)
    prepare_half_data(data, params)
  }
)
