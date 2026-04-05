#' Hourly wind observations
#'
#' Hourly wind speed and direction records
#'
#' @format A data frame with 6 variables:
#' \describe{
#'   \item{year}{Integer. Year of observation.}
#'   \item{month}{Integer. Month of observation (1–12).}
#'   \item{day}{Integer. Day of observation (1–31).}
#'   \item{hour}{Integer. Hour of observation (0–23, UTC).}
#'   \item{wspd}{Numeric. Wind speed (m/s).}
#'   \item{wdir}{Numeric. Wind direction (degrees, 0 = North, clockwise).}
#' }
#'
#' @source ERA5 hourly reanalysis sample data.

"wind"
