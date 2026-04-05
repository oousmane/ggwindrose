test_that("geom_windrose() returns a ggplot2 layer", {
  layer <- geom_windrose()
  expect_s3_class(layer, "LayerInstance")
})

test_that("stat_windrose() returns a ggplot2 layer", {
  layer <- stat_windrose()
  expect_s3_class(layer, "LayerInstance")
})

test_that("coord_windrose() returns a CoordPolar object", {
  coord <- coord_windrose()
  expect_s3_class(coord, "CoordPolar")
})

test_that("scale_x_windrose() returns a Scale object", {
  sc <- scale_x_windrose()
  expect_s3_class(sc, "Scale")
})

test_that("scale_x_windrose() accepts all compass options", {
  expect_no_error(scale_x_windrose("4pt"))
  expect_no_error(scale_x_windrose("8pt"))
  expect_no_error(scale_x_windrose("16pt"))
})

test_that("scale_y_windrose() returns a Scale object", {
  expect_s3_class(scale_y_windrose(), "Scale")
})

test_that("scale_fill_windrose() returns a Scale object", {
  expect_s3_class(scale_fill_windrose(), "Scale")
})

test_that("theme_windrose() returns a theme object", {
  expect_s3_class(theme_windrose(), "theme")
})

test_that("full plot builds without error", {
  library(ggplot2)
  p <- ggplot(wind, aes(x = wdir, y = wspd)) +
    geom_windrose() +
    coord_windrose() +
    scale_x_windrose() +
    scale_fill_windrose() +
    theme_windrose()
  expect_no_error(ggplot_build(p))
})
