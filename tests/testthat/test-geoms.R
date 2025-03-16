library(testthat)
library(ggplot2)
library(ggviolinbox)

# Test geom_halfviolin
test_that("geom_halfviolin works", {
  p <- ggplot(mpg, aes(class, hwy)) +
    geom_halfviolin(panel = "right")
  expect_s3_class(p, "ggplot")
})

# Test geom_halfboxplot
test_that("geom_halfboxplot works", {
  p <- ggplot(mpg, aes(class, hwy)) +
    geom_halfboxplot(panel = "left")
  expect_s3_class(p, "ggplot")
})

# Test geom_violinboxplot
test_that("geom_violinboxplot works", {
  p <- ggplot(mpg, aes(class, hwy)) +
    geom_violinboxplot(boxplot = "left", violinplot = "right")
  expect_s3_class(p, "ggplot")
})

# Test ggviolinbox
test_that("ggviolinbox works", {
  p <- ggviolinbox(data = mpg, mapping = aes(class, hwy), boxplot = "left", violinplot = "right")
  expect_s3_class(p, "ggplot")
})
