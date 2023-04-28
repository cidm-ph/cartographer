#' Example datasets with a feature name column and random data
#'
#' This dataset contains random data compatible with the \code{sf.nc} example
#' map data for illustrating cartographer's features. `nc_type_example_1`
#' contains a deliberate error in the county name for a single row, whereas
#'  `nc_type_example_2` contains correct data.
#'
#' @rdname nc_type_example
#' @format
#' Objects of class `data.frame` with 50 and 200 rows respectively, and 2 columns:
#' \describe{
#'   \item{county}{Feature names that match the NAME field of the nc dataset}
#'   \item{type}{Arbitrary categorical data}
#' }
"nc_type_example_1"

#' @rdname nc_type_example
#' @format NULL
"nc_type_example_2"
