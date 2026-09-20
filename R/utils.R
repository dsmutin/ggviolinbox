#' Clip geom to half panel along the discrete axis
#'
#' Works in both x- and y-oriented layers by normalising with
#' \code{ggplot2::flip_data()} before clipping \code{xmin}/\code{xmax}.
#'
#' @param data Layer data returned from the parent geom/stat.
#' @param panel Which half to keep: \code{"left"} or \code{"right"}.
#' @param flipped_aes Whether aesthetics are flipped for this layer.
#' @return Updated layer data.
#' @noRd
clip_half_panel <- function(data, panel, flipped_aes = FALSE) {
  if (is.null(panel) || !panel %in% c("left", "right")) {
    return(data)
  }

  flip <- FALSE
  if (length(flipped_aes) >= 1L && !is.na(flipped_aes[1L])) {
    flip <- isTRUE(flipped_aes[1L])
  } else if ("flipped_aes" %in% names(data)) {
    flip <- any(data$flipped_aes)
  }
  data <- ggplot2::flip_data(data, flip)

  if (panel == "left") {
    data$xmax <- data$x
  } else {
    data$xmin <- data$x
  }

  ggplot2::flip_data(data, flip)
}

NULL
