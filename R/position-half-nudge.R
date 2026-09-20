#' Nudge along the discrete axis
#'
#' A position adjustment that nudges layers along the discrete axis, regardless
#' of whether the layer is x- or y-oriented.
#'
#' @param nudge Distance to nudge.
#' @param side Side of the discrete axis: \code{"left"} or \code{"right"}.
#' @noRd
position_half_nudge <- function(nudge = 0, side = "right") {
  if (!side %in% c("left", "right")) {
    stop("side must be either 'left' or 'right'")
  }

  ggplot2::ggproto(
    NULL, ggplot2::PositionNudge,
    nudge = nudge,
    side = side,
    compute_panel = function(self, data, ...) {
      flip <- any(data$flipped_aes)
      disc <- ggplot2::flipped_names(flip)$x
      shift <- if (self$side == "right") self$nudge else -self$nudge
      data[[disc]] <- data[[disc]] + shift
      data
    }
  )
}

NULL
