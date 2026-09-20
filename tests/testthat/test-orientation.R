library(testthat)
library(ggplot2)
library(ggviolinbox)

expect_renders <- function(p) {
  expect_s3_class(p, "ggplot")
  expect_no_error(ggplotGrob(p))
}

test_that("half geoms render with coord_flip()", {
  p <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "left") +
    coord_flip()
  expect_renders(p)

  p <- ggplot(mpg, aes(class, hwy)) +
    geom_halfviolin(panel = "right") +
    coord_flip()
  expect_renders(p)

  p <- ggplot(mpg, aes(class, hwy)) +
    geom_violinboxplot(boxplot = "left", violinplot = "right") +
    coord_flip()
  expect_renders(p)
})

test_that("half geoms render with y-oriented aesthetics", {
  p <- ggplot(mpg, aes(hwy, class)) + geom_halfboxplot(panel = "left")
  expect_renders(p)

  p <- ggplot(mpg, aes(hwy, class)) + geom_halfviolin(panel = "right")
  expect_renders(p)

  p <- ggplot(mpg, aes(hwy, class)) +
    geom_violinboxplot(boxplot = "left", violinplot = "right")
  expect_renders(p)
})

test_that("half geoms clip along the discrete axis", {
  vert <- ggplot_build(ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "left"))$data[[1]]
  horiz <- ggplot_build(ggplot(mpg, aes(hwy, class)) +
    geom_halfboxplot(panel = "left"))$data[[1]]

  expect_equal(vert$xmax[1], vert$x[1])
  expect_equal(horiz$ymax[1], horiz$y[1])
})

test_that("panel sides produce different half-boxplot output", {
  p_left <- ggplot(mpg, aes(class, hwy)) + geom_halfboxplot(panel = "left")
  p_right <- ggplot(mpg, aes(class, hwy)) + geom_halfboxplot(panel = "right")

  expect_true(!identical(ggplotGrob(p_left), ggplotGrob(p_right)))
})

test_that("geom_violinboxplot nudge works in both orientations", {
  p <- ggplot(mpg, aes(class, hwy)) + geom_violinboxplot(nudge = 0.2)
  expect_renders(p)

  p <- ggplot(mpg, aes(hwy, class)) + geom_violinboxplot(nudge = 0.2)
  expect_renders(p)

  p <- ggplot(mpg, aes(class, hwy)) +
    geom_violinboxplot(nudge = 0.2) +
    coord_flip()
  expect_renders(p)
})

test_that("invalid panel values throw errors", {
  expect_error(geom_halfboxplot(panel = "top"), "panel must be either")
  expect_error(geom_halfviolin(panel = "top"), "panel must be either")
  expect_error(geom_violinboxplot(boxplot = "left", violinplot = "left"),
               "boxplot and violinplot cannot be on the same side")
})
