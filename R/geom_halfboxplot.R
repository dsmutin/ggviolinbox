#' Half-Boxplot
#'
#' This function creates a half-boxplot, which is a mirrored boxplot.
#' It accepts all aesthetics of `geom_boxplot()` and an additional `panel` parameter
#' to control which side of the plot is displayed.
#'
#' @inheritParams ggplot2::geom_boxplot
#' @param outliers Whether to display (`TRUE`) or discard (`FALSE`) outliers.
#'   Same as in `ggplot2::geom_boxplot()`.
#' @param panel Which half of the box to draw. `"left"` / `"right"` clip along
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
#'   geom_halfboxplot(panel = "left") +
#'   theme_minimal()
#'
#' # Horizontal half-boxplot without coord_flip()
#' ggplot(mpg, aes(hwy, class)) +
#'   geom_halfboxplot(panel = "bottom") +
#'   theme_minimal()
geom_halfboxplot <- function(mapping = NULL, data = NULL, stat = "boxplot",
                             position = "dodge", outliers = TRUE,
                             outlier.colour = NULL, outlier.color = NULL, outlier.fill = NULL,
                             outlier.shape = 19, outlier.size = 1.5, outlier.stroke = 0.5,
                             outlier.alpha = NULL,
                             notch = FALSE, notchwidth = 0.5, varwidth = FALSE, na.rm = FALSE,
                             orientation = NA,
                             show.legend = NA, inherit.aes = TRUE, panel = "left",
                             nudge = 0, ...) {
  check_panel(panel)

  outlier_gp <- list(
    colour = if (!is.null(outlier.color)) outlier.color else outlier.colour,
    fill = outlier.fill,
    shape = outlier.shape,
    size = outlier.size,
    stroke = outlier.stroke,
    alpha = outlier.alpha
  )

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomHalfBoxplot,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      outliers = outliers,
      outlier_gp = outlier_gp,
      notch = notch,
      notchwidth = notchwidth,
      varwidth = varwidth,
      na.rm = na.rm,
      orientation = orientation,
      panel = panel,
      nudge = nudge,
      ...
    )
  )
}

#' GeomHalfBoxplot ggproto object
#'
#' The ggproto object used by \code{\link{geom_halfboxplot}} to render half-boxplots.
#' @rdname geom_halfboxplot
#' @format NULL
#' @usage NULL
#' @keywords internal
#' @export
GeomHalfBoxplot <- ggplot2::ggproto(
  "GeomHalfBoxplot", ggplot2::GeomBoxplot,
  extra_params = c("na.rm", "orientation", "outliers", "panel", "nudge"),
  setup_data = function(self, data, params) {
    data <- ggplot2::ggproto_parent(ggplot2::GeomBoxplot, self)$setup_data(data, params)
    prepare_half_data(data, params)
  }
)
