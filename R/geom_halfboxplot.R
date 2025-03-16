#' Half-Boxplot
#'
#' This function creates a half-boxplot, which is a mirrored boxplot.
#' It accepts all aesthetics of `geom_boxplot()` and an additional `panel` parameter
#' to control which side of the plot is displayed.
#'
#' @inheritParams ggplot2::geom_boxplot
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
                             position = "dodge", outlier.colour = NULL, outlier.shape = 19,
                             outlier.size = 1.5, outlier.stroke = 0.5, outlier.alpha = NULL,
                             notch = FALSE, notchwidth = 0.5, varwidth = FALSE, na.rm = FALSE,
                             show.legend = NA, inherit.aes = TRUE, panel = "left", ...) {
  # Validate panel parameter
  if (!panel %in% c("left", "right")) {
    stop("panel must be either 'left' or 'right'")
  }

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
      outlier.colour = outlier.colour,
      outlier.shape = outlier.shape,
      outlier.size = outlier.size,
      outlier.stroke = outlier.stroke,
      outlier.alpha = outlier.alpha,
      notch = notch,
      notchwidth = notchwidth,
      varwidth = varwidth,
      na.rm = na.rm,
      panel = panel,
      ...
    )
  )
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomHalfBoxplot <- ggplot2::ggproto(
  "GeomHalfBoxplot", ggplot2::GeomBoxplot,
  draw_group = function(data, panel, ...) {
    # Clip the boxplot to show only the left or right half
    if (panel == "left") {
      data$xmax <- data$x
    } else if (panel == "right") {
      data$xmin <- data$x
    }
    ggplot2::GeomBoxplot$draw_group(data, ...)
  }
)
