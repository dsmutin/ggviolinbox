library(testthat)
library(ggplot2)
library(ggviolinbox)

# Helper to compare rendered output via gtable
plots_differ <- function(p1, p2) {
  g1 <- ggplotGrob(p1)
  g2 <- ggplotGrob(p2)
  !identical(g1, g2)
}

# Test geom_halfboxplot outlier properties actually affect the rendered plot

test_that("geom_halfboxplot outlier.colour changes output", {
  p_default <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right")
  p_red <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right", outlier.colour = "red")

  expect_true(plots_differ(p_default, p_red))
})

test_that("geom_halfboxplot outlier.color changes output", {
  p_default <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right")
  p_red <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right", outlier.color = "red")

  expect_true(plots_differ(p_default, p_red))
})

test_that("geom_halfboxplot outlier.size changes output", {
  p_default <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right")
  p_big <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right", outlier.size = 5)

  expect_true(plots_differ(p_default, p_big))
})

test_that("geom_halfboxplot outlier.alpha changes output", {
  p_default <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right")
  p_alpha <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right", outlier.alpha = 0.3)

  expect_true(plots_differ(p_default, p_alpha))
})

test_that("geom_halfboxplot outlier.shape changes output", {
  p_default <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right")
  p_shape <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "right", outlier.shape = 5)

  expect_true(plots_differ(p_default, p_shape))
})