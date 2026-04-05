# Compute a calm-wind label for use in guide_windrose()

Returns a formatted string (e.g. `"Calm: 6.0%"`) to pass as `calm_text`
in
[`guide_windrose()`](https://oousmane.github.io/ggwindrose/reference/guide_windrose.md).

## Usage

``` r
windrose_calm_pct(wspd, threshold = 0.5, digits = 1, label = "Calm: ")
```

## Arguments

- wspd:

  Numeric vector of wind speeds.

- threshold:

  Observations with speed \\\le\\ `threshold` are considered calm.
  Default `0.5`.

- digits:

  Number of decimal places. Default `1`.

- label:

  Label prefix. Default `"Calm: "`.

## Value

A `character(1)` string, e.g. `"Calm: 6.0%"`.

## Examples

``` r
x <- c(0, 0, 0.3, 1.2, 3.4, 5.6)
windrose_calm_pct(x)                   # "Calm: 50.0%"
#> [1] "Calm: 50.0%"
windrose_calm_pct(x, threshold = 1.0)  # includes 0.3 in calm
#> [1] "Calm: 50.0%"
windrose_calm_pct(x, label = "Calme: ")
#> [1] "Calme: 50.0%"
```
