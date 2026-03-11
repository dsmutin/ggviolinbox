#' Violin-Boxplot Combination
#'
#' This function creates a combination of a half-violin and a half-boxplot.
#' It allows specifying which side the boxplot and violin plot should appear on.
#'
#' @inheritParams ggplot2::geom_violin
#' @inheritParams ggplot2::geom_boxplot
#' @param stat The statistical transformation to use on the data. Defaults to
#'   \code{\"ydensity\"} as in \code{ggplot2::geom_violin()}.
#' @param outlier.colour,outlier.color Colour for outlier points in the
#'   half-boxplot part. If \code{NULL}, inherits from the box colour.
#' @param outlier.shape Shape of outlier points in the half-boxplot part.
#' @param outlier.size Size of outlier points in the half-boxplot part.
#' @param outlier.stroke Stroke width for outlier points in the half-boxplot part.
#' @param outlier.alpha Alpha transparency for outlier points in the
#'   half-boxplot part.
#' @param boxplot A character string specifying which side the boxplot should appear on.
#'   Must be either "left" or "right". Default is "left".
#' @param violinplot A character string specifying which side the violin plot should appear on.
#'   Must be either "left" or "right". Default is "right".
#' @param nudge Numeric. Horizontal nudge applied via \code{\link[ggplot2:position_nudge]{position_nudge}(x = nudge)}:
#'   the geom on the right uses \code{+nudge}, the geom on the left uses \code{-nudge}.
#'   Use \code{0} (default) for no nudge.
#' @import ggplot2
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_violinboxplot(boxplot = "left", violinplot = "right") +
#'   theme_minimal()
geom_violinboxplot <- function(mapping = NULL, data = NULL, stat = "ydensity",
                               position = "dodge", trim = TRUE, scale = "area",
                               outlier.colour = NULL, outlier.color = NULL, outlier.shape = 19,
                               outlier.size = 1.5, outlier.stroke = 0.5, outlier.alpha = NULL,
                               notch = FALSE, notchwidth = 0.5, varwidth = FALSE, na.rm = FALSE,
                               show.legend = NA, inherit.aes = TRUE, boxplot = "left", violinplot = "right",
                               nudge = 0, ...) {
  # Validate boxplot and violinplot parameters
  if (!boxplot %in% c("left", "right")) {
    stop("boxplot must be either 'left' or 'right'")
  }
  if (!violinplot %in% c("left", "right")) {
    stop("violinplot must be either 'left' or 'right'")
  }
  if (boxplot == violinplot) {
    stop("boxplot and violinplot cannot be on the same side")
  }

  # Position with nudge: right geom +nudge, left geom -nudge
  pos_violin <- if (nudge != 0) {
    ggplot2::position_nudge(x = if (violinplot == "right") nudge else -nudge)
  } else {
    position
  }
  pos_box <- if (nudge != 0) {
    ggplot2::position_nudge(x = if (boxplot == "right") nudge else -nudge)
  } else {
    position
  }

  # Create a list of layers
  list(
    geom_halfviolin(
      mapping = mapping, data = data, stat = stat, position = pos_violin,
      trim = trim, scale = scale, show.legend = show.legend,
      inherit.aes = inherit.aes, panel = violinplot, ...
    ),
    geom_halfboxplot(
      mapping = mapping, data = data, stat = "boxplot", position = pos_box,
      outlier.colour = outlier.colour, outlier.color = outlier.color, outlier.shape = outlier.shape,
      outlier.size = outlier.size, outlier.stroke = outlier.stroke,
      outlier.alpha = outlier.alpha, notch = notch, notchwidth = notchwidth,
      varwidth = varwidth, na.rm = na.rm, show.legend = show.legend,
      inherit.aes = inherit.aes, panel = boxplot, ...
    )
  )
}

#' @rdname geom_violinboxplot
#' @export
ggviolinbox <- function(mapping = NULL, data = NULL, boxplot = "left", violinplot = "right", ...) {
  # Call geom_violinboxplot with the provided parameters
  ggplot() +
    geom_violinboxplot(
      mapping = mapping, data = data, boxplot = boxplot, violinplot = violinplot, ...
    )
}
