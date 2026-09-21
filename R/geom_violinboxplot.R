#' Violin-Boxplot Combination
#'
#' This function creates a combination of a half-violin and a half-boxplot.
#' It allows specifying which side the boxplot and violin plot should appear on.
#'
#' @inheritParams ggplot2::geom_violin
#' @inheritParams ggplot2::geom_boxplot
#' @param stat The statistical transformation to use on the data. Defaults to
#'   \code{"ydensity"} as in \code{ggplot2::geom_violin()}.
#' @param outlier.colour,outlier.color Colour for outlier points in the
#'   half-boxplot part. If \code{NULL}, inherits from the box colour.
#' @param outlier.shape Shape of outlier points in the half-boxplot part.
#' @param outlier.size Size of outlier points in the half-boxplot part.
#' @param outlier.stroke Stroke width for outlier points in the half-boxplot part.
#' @param outlier.alpha Alpha transparency for outlier points in the
#'   half-boxplot part.
#' @param boxplot Side for the boxplot: `"left"`, `"right"`, `"bottom"`, or `"top"`.
#'   Default is `"left"`.
#' @param violinplot Side for the violin: `"left"`, `"right"`, `"bottom"`, or `"top"`.
#'   Default is `"right"`.
#' @param nudge Numeric offset along the grouping axis (x when vertical, y when
#'   horizontal). The geom on the `"right"`/`"top"` side is shifted by
#'   \code{+nudge}; the geom on the `"left"`/`"bottom"` side by \code{-nudge}.
#'   Use \code{0} (default) for no offset. Unlike a `position_nudge()` replacement,
#'   this keeps the requested \code{position} (e.g. dodge).
#' @import ggplot2
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, hwy)) +
#'   geom_violinboxplot(boxplot = "left", violinplot = "right") +
#'   theme_minimal()
#'
#' ggplot(mpg, aes(hwy, class)) +
#'   geom_violinboxplot(boxplot = "bottom", violinplot = "top") +
#'   theme_minimal()
geom_violinboxplot <- function(mapping = NULL, data = NULL, stat = "ydensity",
                               position = "dodge", trim = TRUE, scale = "area",
                               outlier.colour = NULL, outlier.color = NULL, outlier.shape = 19,
                               outlier.size = 1.5, outlier.stroke = 0.5, outlier.alpha = NULL,
                               notch = FALSE, notchwidth = 0.5, varwidth = FALSE, na.rm = FALSE,
                               orientation = NA,
                               show.legend = NA, inherit.aes = TRUE, boxplot = "left",
                               violinplot = "right",
                               nudge = 0, ...) {
  check_panel(boxplot, arg = "boxplot")
  check_panel(violinplot, arg = "violinplot")
  if (canonical_side(boxplot) == canonical_side(violinplot)) {
    stop("`boxplot` and `violinplot` cannot be on the same side.", call. = FALSE)
  }

  nudge_violin <- if (canonical_side(violinplot) == "high") nudge else -nudge
  nudge_box <- if (canonical_side(boxplot) == "high") nudge else -nudge

  list(
    geom_halfviolin(
      mapping = mapping, data = data, stat = stat, position = position,
      trim = trim, scale = scale, na.rm = na.rm, orientation = orientation,
      show.legend = show.legend, inherit.aes = inherit.aes, panel = violinplot,
      nudge = nudge_violin, ...
    ),
    geom_halfboxplot(
      mapping = mapping, data = data, stat = "boxplot", position = position,
      outlier.colour = outlier.colour, outlier.color = outlier.color,
      outlier.shape = outlier.shape, outlier.size = outlier.size,
      outlier.stroke = outlier.stroke, outlier.alpha = outlier.alpha,
      notch = notch, notchwidth = notchwidth, varwidth = varwidth, na.rm = na.rm,
      orientation = orientation, show.legend = show.legend,
      inherit.aes = inherit.aes, panel = boxplot, nudge = nudge_box, ...
    )
  )
}

#' @rdname geom_violinboxplot
#' @export
ggviolinbox <- function(mapping = NULL, data = NULL, boxplot = "left", violinplot = "right", ...) {
  ggplot2::ggplot(data = data, mapping = mapping) +
    geom_violinboxplot(
      boxplot = boxplot, violinplot = violinplot, ...
    )
}
