#' Convert input data frame into a spatial data frame
#'
#' @param x Data frame with a feature name column.
#' @param location Feature names (tidy evaluation).
#' @param feature_type The registered map corresponding to values in \code{location}.
#'   If NA (the default), the type is guessed from the values in \code{location}.
#' @param geom_name Name for the new column to contain the geometry.
#'
#' @returns A spatial data frame containing all of the columns from the input
#'   data frame.
#'
#' @importFrom rlang :=
#' @export
#'
#' @examples
#' add_geometry(nc_type_example_2, county)
add_geometry <- function(x, location, feature_type = NA, geom_name = "geometry") {
  if (missing(location))
    cli::cli_abort("{.arg location} is absent but must be supplied.")

  location_data <- dplyr::pull(x, {{ location }})
  feature_type <- resolve_feature_type(feature_type, location_data)
  location_data <- resolve_feature_names(location_data, feature_type)

  matches <- match(location_data, get_feature_names(feature_type))
  geometry <- sf::st_geometry(map_sf(feature_type))
  x <- dplyr::mutate(x, {{ geom_name }} := geometry[matches])
  sf::st_sf(x, sf_column_name = geom_name)
}
