#' Half-Violin Plot
#'
#' This function creates a half-violin plot, which is a mirrored density plot.
#' It accepts all aesthetics of `geom_violin()` and an additional `panel` parameter
#' to control which side of the plot is displayed.
#'
#' @inheritParams ggplot2::geom_violin
#' @param panel A character string specifying which side of the plot to display.
#'   Must be either "left" or "right". Default is "left".
#' @import ggplot2
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_halfviolin(panel = "right") +
#'   theme_minimal()
geom_halfviolin <- function(mapping = NULL, data = NULL, stat = "ydensity",
                            position = "dodge", trim = TRUE, scale = "area",
                            show.legend = NA, inherit.aes = TRUE, panel = "left", ...) {
  # Validate panel parameter
  if (!panel %in% c("left", "right")) {
    stop("panel must be either 'left' or 'right'")
  }

  # Create a layer for half-violin
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
      panel = panel,
      ...
    )
  )
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomHalfViolin <- ggplot2::ggproto(
  "GeomHalfViolin", ggplot2::GeomViolin,
  draw_group = function(data, panel, ...) {
    # Clip the violin to show only the left or right half
    if (panel == "left") {
      data$xmax <- data$x
    } else if (panel == "right") {
      data$xmin <- data$x
    }
    ggplot2::GeomViolin$draw_group(data, ...)
  }
)