test_that("windrose_calm_pct returns correct format", {
  x <- c(0, 0, 1, 2, 3, 4)
  expect_match(windrose_calm_pct(x), "^Calm: \\d+\\.\\d+%$")
})

test_that("windrose_calm_pct computes correct percentage", {
  x <- c(0, 0, 1, 2, 3, 4)   # 2 of 6 <= 0.5  → 33.3%
  expect_equal(windrose_calm_pct(x), "Calm: 33.3%")
})

test_that("windrose_calm_pct respects threshold argument", {
  x <- c(0, 0.3, 0.5, 1, 2)   # threshold = 1.0 → 4 of 5 → 80%
  expect_equal(windrose_calm_pct(x, threshold = 1.0), "Calm: 80.0%")
})

test_that("windrose_calm_pct respects label argument", {
  x <- c(0, 1, 2)
  result <- windrose_calm_pct(x, label = "Calme : ")
  expect_match(result, "^Calme : ")
})

test_that("windrose_calm_pct errors on non-numeric input", {
  expect_error(windrose_calm_pct(c("a", "b")), "`wspd` must be a numeric vector")
})
