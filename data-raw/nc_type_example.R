library(cartographer)

set.seed(1234)

n_rows <- 50
counties <- sample(feature_names("sf.nc"), size = 5) |>
  sample(size = n_rows - 1, replace = TRUE, prob = c(2, 5, 1, 1, 1))
# add one misspelled county as an example
counties <- c(counties, "Pamilco")
types <- sample(c("A", "B"), size = n_rows, replace = TRUE, prob = c(3, 7))

nc_type_example <- data.frame(county = toupper(counties), type = types)

usethis::use_data(nc_type_example, overwrite = TRUE)
