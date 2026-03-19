test_that("retrieves geometry column", {
  locations <- nc_type_example_2$county[1:30]
  geom <- get_geometry(locations, feature_type = "sf.nc")
  expect_length(geom, 30L)
})

test_that("add_geometry supports tidy evaluation", {
  x <- add_geometry(
    head(nc_type_example_2, n = 30),
    county,
    feature_type = "sf.nc"
  )
  expect_length(sf::st_geometry(x), 30L)
})

test_that("feature type can be guessed", {
  x <- add_geometry(nc_type_example_2, county)
  expect_length(sf::st_geometry(x), nrow(nc_type_example_2))
})
