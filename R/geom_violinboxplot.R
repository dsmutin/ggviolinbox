#' Violin-Boxplot Combination
#'
#' This function creates a combination of a half-violin and a half-boxplot.
#' It allows specifying which side the boxplot and violin plot should appear on.
#'
#' @inheritParams ggplot2::geom_violin
#' @inheritParams ggplot2::geom_boxplot
#' @param boxplot A character string specifying which side the boxplot should appear on.
#'   Must be either "left" or "right". Default is "left".
#' @param violinplot A character string specifying which side the violin plot should appear on.
#'   Must be either "left" or "right". Default is "right".
#' @import ggplot2
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_violinboxplot(boxplot = "left", violinplot = "right") +
#'   theme_minimal()
geom_violinboxplot <- function(mapping = NULL, data = NULL, stat = "ydensity",
                               position = "dodge", trim = TRUE, scale = "area",
                               outlier.colour = NULL, outlier.shape = 19,
                               outlier.size = 1.5, outlier.stroke = 0.5, outlier.alpha = NULL,
                               notch = FALSE, notchwidth = 0.5, varwidth = FALSE, na.rm = FALSE,
                               show.legend = NA, inherit.aes = TRUE, boxplot = "left", violinplot = "right", ...) {
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

  # Create a list of layers
  list(
    geom_halfviolin(
      mapping = mapping, data = data, stat = stat, position = position,
      trim = trim, scale = scale, show.legend = show.legend,
      inherit.aes = inherit.aes, panel = violinplot, ...
    ),
    geom_halfboxplot(
      mapping = mapping, data = data, stat = "boxplot", position = position,
      outlier.colour = outlier.colour, outlier.shape = outlier.shape,
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
