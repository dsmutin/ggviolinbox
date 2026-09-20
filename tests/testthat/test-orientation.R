library(testthat)
library(ggplot2)
library(ggviolinbox)

build_data <- function(p, layer = 1) {
  ggplot_build(p)$data[[layer]]
}

test_that("vertical half-violin clips xmin/xmax on the grouping axis", {
  p_left <- ggplot(mpg, aes(class, hwy)) + geom_halfviolin(panel = "left")
  p_right <- ggplot(mpg, aes(class, hwy)) + geom_halfviolin(panel = "right")
  d_left <- build_data(p_left)
  d_right <- build_data(p_right)

  expect_equal(d_left$xmax, d_left$x)
  expect_true(all(d_left$xmin < d_left$x))
  expect_equal(d_right$xmin, d_right$x)
  expect_true(all(d_right$xmax > d_right$x))
  expect_error(ggplotGrob(p_left), NA)
  expect_error(ggplotGrob(p_right), NA)
})

test_that("horizontal half-violin clips ymin/ymax without coord_flip()", {
  p_bottom <- ggplot(mpg, aes(hwy, class)) + geom_halfviolin(panel = "bottom")
  p_top <- ggplot(mpg, aes(hwy, class)) + geom_halfviolin(panel = "top")
  p_left <- ggplot(mpg, aes(hwy, class)) + geom_halfviolin(panel = "left")
  d_bottom <- build_data(p_bottom)
  d_top <- build_data(p_top)
  d_left <- build_data(p_left)

  expect_true(isTRUE(unique(d_bottom$flipped_aes)))
  expect_equal(d_bottom$ymax, d_bottom$y)
  expect_true(all(d_bottom$ymin < d_bottom$y))
  expect_equal(d_top$ymin, d_top$y)
  expect_true(all(d_top$ymax > d_top$y))
  # left aliases bottom when flipped
  expect_equal(d_left$ymax, d_left$y)
  expect_error(ggplotGrob(p_bottom), NA)
  expect_error(ggplotGrob(p_top), NA)
})

test_that("vertical half-boxplot clips xmin/xmax on the grouping axis", {
  p_left <- ggplot(mpg, aes(class, hwy)) + geom_halfboxplot(panel = "left")
  p_right <- ggplot(mpg, aes(class, hwy)) + geom_halfboxplot(panel = "right")
  d_left <- build_data(p_left)
  d_right <- build_data(p_right)

  expect_equal(d_left$xmax, d_left$x)
  expect_true(all(d_left$xmin < d_left$x))
  expect_equal(d_right$xmin, d_right$x)
  expect_true(all(d_right$xmax > d_right$x))
  expect_error(ggplotGrob(p_left), NA)
  expect_error(ggplotGrob(p_right), NA)
})

test_that("horizontal half-boxplot clips ymin/ymax without coord_flip()", {
  p_bottom <- ggplot(mpg, aes(hwy, class)) + geom_halfboxplot(panel = "bottom")
  p_top <- ggplot(mpg, aes(hwy, class)) + geom_halfboxplot(panel = "top")
  d_bottom <- build_data(p_bottom)
  d_top <- build_data(p_top)

  expect_true(isTRUE(unique(d_bottom$flipped_aes)))
  expect_equal(d_bottom$ymax, d_bottom$y)
  expect_true(all(d_bottom$ymin < d_bottom$y))
  expect_equal(d_top$ymin, d_top$y)
  expect_true(all(d_top$ymax > d_top$y))
  expect_error(ggplotGrob(p_bottom), NA)
  expect_error(ggplotGrob(p_top), NA)
})

test_that("geom_violinboxplot renders in both orientations", {
  p_x <- ggplot(mpg, aes(class, hwy)) +
    geom_violinboxplot(boxplot = "left", violinplot = "right")
  p_y <- ggplot(mpg, aes(hwy, class)) +
    geom_violinboxplot(boxplot = "bottom", violinplot = "top")
  expect_error(ggplotGrob(p_x), NA)
  expect_error(ggplotGrob(p_y), NA)

  d_y_violin <- build_data(p_y, 1)
  d_y_box <- build_data(p_y, 2)
  expect_equal(d_y_violin$ymin, d_y_violin$y)
  expect_equal(d_y_box$ymax, d_y_box$y)
})

test_that("nudge shifts geoms along the grouping axis", {
  p0 <- ggplot(mpg, aes(class, hwy)) +
    geom_halfviolin(panel = "right", nudge = 0)
  p1 <- ggplot(mpg, aes(class, hwy)) +
    geom_halfviolin(panel = "right", nudge = 0.2)
  expect_equal(build_data(p1)$x, build_data(p0)$x + 0.2)

  p0y <- ggplot(mpg, aes(hwy, class)) +
    geom_halfviolin(panel = "top", nudge = 0)
  p1y <- ggplot(mpg, aes(hwy, class)) +
    geom_halfviolin(panel = "top", nudge = 0.2)
  expect_equal(build_data(p1y)$y, build_data(p0y)$y + 0.2)
})

test_that("orientation can be set explicitly", {
  p <- ggplot(mpg, aes(hwy, class)) +
    geom_halfviolin(panel = "top", orientation = "y")
  expect_true(isTRUE(unique(build_data(p)$flipped_aes)))
  expect_error(ggplotGrob(p), NA)
})
