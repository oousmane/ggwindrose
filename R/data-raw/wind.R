
#  Prepare and bundle the Terkora hourly wind dataset.


library(readr)
library(dplyr)

wind <- read_csv2(
  "/Volumes/OUSMANE/torkera.csv",
  col_names = FALSE,
  col_types = cols(.default = col_double())
) |>
  `colnames<-`(c("year", "month", "day", "hour", "wspd", "wdir")) |>
  mutate(
    year  = as.integer(year),
    month = as.integer(month),
    day   = as.integer(day),
    hour  = as.integer(hour),
    wspd  = as.numeric(wspd),
    wdir  = as.numeric(wdir)
  ) |>
  # Basic sanity filters
  filter(
    !is.na(wspd), !is.na(wdir),
    wspd >= 0,
    wdir >= 0, wdir <= 360
  )

usethis::use_data(wind, overwrite = TRUE, compress = "xz")
