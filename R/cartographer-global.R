cartographer_global <- new.env(parent = emptyenv())

#' Register a new feature type
#'
#' This adds a new feature type that can then be used by all the geoms in this
#' package. If registering from another package, this should occur in the
#' \code{.onLoad()} hook in the package.
#'
#' Registration supports delayed evaluation (lazy loading). This is particularly
#' useful for larger datasets, so that they are not loaded into memory until
#' they are accessed.
#'
#' @param feature_type Name of the type. If registering from within a package,
#'   the suggested format is \code{"<package name>.<map name>"} to avoid clashes
#'   between packages.
#' @param data A simple feature data frame with the map data, or a function
#'   that returns a data frame. When \code{lazy} is \code{TRUE}, the function
#'   will not be called until the data is first accessed.
#' @param feature_column Name of the column of \code{data} that contains the
#'   feature names.
#' @param aliases Optional named character vector or list that maps aliases to
#'   values that appear in the feature column. This allows abbreviations or
#'   alternative names to be supported.
#' @param outline Optional sf geometry containing just the outline of the map.
#' @param lazy When \code{TRUE}, defer evaluation of \code{data} until it is
#'   used.
#'
#' @returns No return value; this updates the global feature registry.
#' @export
#'
#' @examples
#' # in R/zzz.R
#' .onLoad <- function(libname, pkgname) {
#'    cartographer::register_map(
#'      "sf.nc",
#'      data = function () {
#'        sf::st_read(system.file("shape/nc.shp", package = "sf"))
#'      },
#'      feature_column = "NAME"
#'    )
#' }
register_map <- function(feature_type, data, feature_column,
                         aliases = NULL, outline = NULL, lazy = TRUE) {
  if (is.null(aliases)) aliases <- character(0)

  if (lazy) {
    delayedAssign(feature_type,
      list(
        data = validate_map_data(if (is.function(data)) data() else data,
                                 feature_column),
        feature_column = feature_column,
        aliases = aliases,
        outline = outline
      ),
      assign.env = cartographer_global
    )
  } else {
    cartographer_global[[feature_type]] <- list(
      data = validate_map_data(if (is.function(data)) data() else data,
                               feature_column),
      feature_column = feature_column,
      aliases = aliases,
      outline = outline
    )
  }
}

validate_map_data <- function(data, feature_column) {
  if (!inherits(data, "sf")) {
    cli::cli_abort("{.arg data} must be an sf object, not {class(data)}")
  }
  if (!feature_column %in% names(data)) {
    cli::cli_abort("{.field feature_column} {feature_column} not found")
  }
  invisible(data)
}

#' List known feature types
#'
#' Each feature type corresponds to map data that has been registered.
#'
#' @seealso [register_map()]
#'
#' @returns Character vector of registered feature types.
#' @export
#' @examples
#' feature_types()
feature_types <- function() {
  names(cartographer_global)
}

#' List known feature names
#'
#' This gives the list of feature names that are part of the specified map data.
#' The list includes any aliases defined when the map was registered. Note that
#' the \code{location} column matching is case insensitive (see Details below).
#'
#' @seealso [register_map()] and [resolve_feature_names()]
#'
#' @param feature_type Type of map feature. See [feature_types()] for a list of
#'   registered types.
#'
#' @returns Character vector of feature names.
#' @export
#'
#' @examples
#' feature_names("sf.nc")
feature_names <- function(feature_type) {
  if (is.na(feature_type)) cli::cli_abort("Must specify a {.arg feature_type}")
  names <- get_feature_names(feature_type)
  aliases <- map_aliases(feature_type)
  c(names, unname(aliases))
}

get_feature_names <- function(feature_type) {
  cfg <- cartographer_global[[feature_type]]
  if (is.null(cfg)) cli::cli_abort("Unknown feature type {feature_type}")
  cfg$data[[cfg$feature_column]]
}

get_geom_feature_column <- function(feature_type) {
  cfg <- cartographer_global[[feature_type]]
  if (is.null(cfg)) cli::cli_abort("Unknown feature type {feature_type}")
  cfg$feature_column
}

#' Retrieve map data registered with cartographer.
#'
#' @param feature_type Type of map feature. See [feature_types()] for a list of
#'   registered types.
#'
#' @returns The spatial data frame that was registered under `feature_type`.
#' @export
#'
#' @examples
#' map_sf("sf.nc")
map_sf <- function(feature_type) {
  cfg <- cartographer_global[[feature_type]]
  if (is.null(cfg)) cli::cli_abort("Unknown feature type {feature_type}")
  cfg$data
}

get_geometry_loc <- function(feature_type, feature_name) {
  geoms <- map_sf(feature_type)
  geom_locations <- get_geom_feature_column(feature_type)
  geom_locations <- unlist(unclass(geoms)[geom_locations])

  if (!(feature_name %in% geom_locations)) {
    cli::cli_abort("Location {feature_name} is not a known {feature_type} feature")
  }
  sf::st_geometry(geoms[geom_locations == feature_name,][1,])
}

map_aliases <- function(feature_type) {
  cfg <- cartographer_global[[feature_type]]
  if (is.null(cfg)) cli::cli_abort("Unknown feature type {feature_type}")
  cfg$aliases
}

#' Retrieve a map outline registered with cartographer.
#'
#' @param feature_type Type of map feature. See [feature_types()] for a list of
#'   registered types.
#'
#' @returns The map outline that was registered under `feature_type`. Note that
#'   the outline is optional, so this will return `NULL` if none was registered.
#' @export
#'
#' @examples
#' map_outline("sf.nc")
map_outline <- function(feature_type) {
  cfg <- cartographer_global[[feature_type]]
  if (is.null(cfg)) cli::cli_abort("Unknown feature type {feature_type}")
  cfg$outline
}
