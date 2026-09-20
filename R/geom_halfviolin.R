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
                            na.rm = FALSE, show.legend = NA, inherit.aes = TRUE,
                            panel = "left", orientation = NA, ...) {
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
      na.rm = na.rm,
      panel = panel,
      orientation = orientation,
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
  extra_params = c("na.rm", "orientation", "lineend", "linejoin", "linemitre", "panel"),
  setup_data = function(self, data, params) {
    data <- ggplot2::ggproto_parent(ggplot2::GeomViolin, self)$setup_data(data, params)

    flipped_aes <- params$flipped_aes
    if (is.null(flipped_aes) && "flipped_aes" %in% names(data)) {
      flipped_aes <- data$flipped_aes
    }

    clip_half_panel(
      data,
      panel = params$panel,
      flipped_aes = flipped_aes
    )
  }
)
