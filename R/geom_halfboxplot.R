#' Half-Boxplot
#'
#' This function creates a half-boxplot, which is a mirrored boxplot.
#' It accepts all aesthetics of `geom_boxplot()` and an additional `panel` parameter
#' to control which side of the plot is displayed.
#'
#' @inheritParams ggplot2::geom_boxplot
#' @param outliers Whether to display (`TRUE`) or discard (`FALSE`) outliers.
#'   Same as in `ggplot2::geom_boxplot()`.
#' @param panel A character string specifying which side of the plot to display.
#'   Must be either "left" or "right". Default is "left".
#' @import ggplot2
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_halfboxplot(panel = "left") +
#'   theme_minimal()
geom_halfboxplot <- function(mapping = NULL, data = NULL, stat = "boxplot",
                             position = "dodge", outliers = TRUE,
                             outlier.colour = NULL, outlier.color = NULL, outlier.fill = NULL,
                             outlier.shape = 19, outlier.size = 1.5, outlier.stroke = 0.5,
                             outlier.alpha = NULL,
                             notch = FALSE, notchwidth = 0.5, varwidth = FALSE, na.rm = FALSE,
                             show.legend = NA, inherit.aes = TRUE, panel = "left", ...) {
  # Validate panel parameter
  if (!panel %in% c("left", "right")) {
    stop("panel must be either 'left' or 'right'")
  }

  # Build outlier_gp so parent GeomBoxplot draw_group receives outlier aesthetics
  outlier_gp <- list(
    colour = if (!is.null(outlier.color)) outlier.color else outlier.colour,
    fill = outlier.fill,
    shape = outlier.shape,
    size = outlier.size,
    stroke = outlier.stroke,
    alpha = outlier.alpha
  )

  # Create a layer for half-boxplot
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
      panel = panel,
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
  extra_params = c("na.rm", "orientation", "outliers", "panel",
                   "outlier_gp", "notch", "notchwidth", "varwidth"),
  setup_data = function(self, data, params) {
    # First let GeomBoxplot compute all boxplot statistics and widths
    data <- ggplot2::ggproto_parent(ggplot2::GeomBoxplot, self)$setup_data(data, params)

    panel_side <- params$panel
    if (is.null(panel_side) || panel_side == "left") {
      # Keep only the left half: clamp xmax at the box centre
      data$xmax <- data$x
    } else if (panel_side == "right") {
      # Keep only the right half: clamp xmin at the box centre
      data$xmin <- data$x
    }

    data
  }
)
