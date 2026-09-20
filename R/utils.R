# Internal helpers shared by half-violin / half-boxplot geoms

.panel_choices <- c("left", "right", "bottom", "top")

check_panel <- function(panel, arg = "panel") {
  if (length(panel) != 1L || !is.character(panel) || !panel %in% .panel_choices) {
    stop(
      sprintf("`%s` must be one of 'left', 'right', 'bottom', or 'top'.", arg),
      call. = FALSE
    )
  }
  invisible(panel)
}

# Map sides onto the grouping axis in standard (unflipped) coordinates:
# left/bottom = smaller values, right/top = larger values.
# This matches aes(x, y) + coord_flip() vs aes(y, x) native orientation.
canonical_side <- function(panel) {
  if (panel %in% c("left", "bottom")) "low" else "high"
}

clip_half_side <- function(data, panel) {
  if (canonical_side(panel) == "low") {
    data$xmax <- data$x
  } else {
    data$xmin <- data$x
  }
  data
}

nudge_grouping_axis <- function(data, nudge) {
  if (is.null(nudge) || length(nudge) == 0L || isTRUE(all.equal(nudge, 0))) {
    return(data)
  }
  data$x <- data$x + nudge
  if ("xmin" %in% names(data)) {
    data$xmin <- data$xmin + nudge
  }
  if ("xmax" %in% names(data)) {
    data$xmax <- data$xmax + nudge
  }
  data
}

# Clip (and optionally nudge) after parent setup_data, in standard orientation.
prepare_half_data <- function(data, params) {
  flipped <- isTRUE(params$flipped_aes)
  panel <- params$panel
  if (is.null(panel)) {
    panel <- "left"
  }
  data <- ggplot2::flip_data(data, flipped)
  data <- clip_half_side(data, panel)
  data <- nudge_grouping_axis(data, params$nudge)
  ggplot2::flip_data(data, flipped)
}
