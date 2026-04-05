test_that(".compute_windrose returns correct structure", {
  wdir <- c(0, 45, 90, 135, 180, 225, 270, 315)
  wspd <- c(1, 2, 3, 4, 5, 6, 7, 8)
  out  <- ggwindrose:::.compute_windrose(wdir, wspd, n_dir = 8)

  expect_s3_class(out, "data.frame")
  expect_named(out, c("x", "y", "speed_class", "calm_pct"))
  expect_true(all(out$y >= 0))
})

test_that(".compute_windrose frequencies sum to (100 - calm_pct)", {
  set.seed(1)
  wdir <- sample(0:359, 200, replace = TRUE)
  wspd <- c(rep(0, 20), runif(180, 0.6, 10))
  out  <- ggwindrose:::.compute_windrose(wdir, wspd)

  expected_sum <- 100 - out$calm_pct[[1]]
  expect_equal(sum(out$y), expected_sum, tolerance = 0.01)
})

test_that(".compute_windrose excludes calm observations from bars", {
  wdir <- rep(0, 10)
  wspd <- rep(0, 10)   # all calm
  # All calm — no non-calm rows, result should be empty
  out <- ggwindrose:::.compute_windrose(wdir, wspd, calm_threshold = 0.5)
  expect_equal(nrow(out), 0L)
})

test_that(".compute_windrose errors on mismatched lengths", {
  expect_error(
    ggwindrose:::.compute_windrose(1:5, 1:4),
    "same length"
  )
})

test_that("custom speed_breaks and speed_labels are respected", {
  wdir <- rep(90, 10)
  wspd <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  out  <- ggwindrose:::.compute_windrose(
    wdir, wspd,
    speed_breaks = c(0.5, 5, Inf),
    speed_labels = c("low", "high")
  )
  expect_setequal(levels(out$speed_class), c("low", "high"))
})
