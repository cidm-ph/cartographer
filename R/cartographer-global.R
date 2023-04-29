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
#'   that returns a data frame. When \code{lazy} is \code{TRUE}, the value
#'   will not be evaluated until the data is first accessed.
#' @param feature_column Name of the column of \code{data} that contains the
#'   feature names.
#' @param aliases Optional named character vector or list that maps aliases to
#'   values that appear in the feature column. This allows abbreviations or
#'   alternative names to be supported.
#' @param outline Optional sf geometry containing just the outline of the map,
#'   or a function returning such a geometry. When \code{lazy} is \code{TRUE},
#'   the value will not be evaluated until the data is first accessed.
#' @param lazy When \code{TRUE}, defer evaluation of \code{data} and
#'   \code{outline} until it is used.
#'
#' @returns No return value; this updates the global feature registry.
#' @seealso `vignette("registering_maps")`
#' @export
#'
#' @examples
#'  # register a map of the states of Italy from rnaturalearth using the
#'  # Italian names, and providing an outline of the country
#'  register_map(
#'    "italy",
#'    data = rnaturalearth::ne_states(country = "italy", returnclass = "sf"),
#'    feature_column = "name_it",
#'    outline = rnaturalearth::ne_countries(country = "italy", returnclass = "sf", scale = "large")
#'  )
register_map <- function(feature_type, data, feature_column,
                         aliases = NULL, outline = NULL, lazy = TRUE) {
  if (is.null(aliases)) aliases <- character(0)

  if (lazy) {
    delayedAssign(feature_type,
      list(
        data = validate_map_data(data, feature_column),
        feature_column = feature_column,
        aliases = aliases,
        outline = validate_outline_data(outline)
      ),
      assign.env = cartographer_global
    )
  } else {
    cartographer_global[[feature_type]] <- list(
      data = validate_map_data(data, feature_column),
      feature_column = feature_column,
      aliases = aliases,
      outline = validate_outline_data(outline)
    )
  }
}

validate_map_data <- function(data, feature_column) {
  if (is.function(data)) data <- data()

  if (!inherits(data, "sf")) {
    cli::cli_abort("{.arg data} must be an sf object, not {class(data)}")
  }
  if (!feature_column %in% names(data)) {
    cli::cli_abort("{.field feature_column} {feature_column} not found in registered data")
  }
  invisible(data)
}

validate_outline_data <- function(data) {
  if (is.null(data)) return(NULL)
  if (is.function(data)) data <- data()

  if (!inherits(data, "sf")) {
    cli::cli_abort("{.arg data} must be an sf object, not {class(data)}")
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

is_promise <- function(ftype) {
  .Call(C_is_promise, as.name(ftype), cartographer_global)
}

promise_was_forced <- function(ftype) {
  .Call(C_promise_was_forced, as.name(ftype), cartographer_global)
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
#' head(feature_names("sf.nc"))
feature_names <- function(feature_type) {
  names <- get_feature_names(feature_type)
  aliases <- map_aliases(feature_type)
  c(names, names(aliases))
}

get_feature_names <- function(feature_type) {
  if (missing(feature_type) || is.na(feature_type)) cli::cli_abort("Must specify a {.arg feature_type}")
  cfg <- cartographer_global[[feature_type]]
  if (is.null(cfg)) cli::cli_abort("Unknown feature type {feature_type}")
  cfg$data[[cfg$feature_column]]
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

#' Retrieve geometry of a single location.
#'
#' @param feature_names Name of the feature(s) to retrieve. This must be an exact
#'   case-sensitive match, and aliases are not consulted.
#' @param feature_type Type of map feature. See [feature_types()] for a list of
#'   registered types.
#'
#' @returns The geometry as a `sfc` object.
#' @export
#'
#' @examples
#' map_sfc("Ashe", "sf.nc")
#' map_sfc(c("Craven", "Buncombe"), "sf.nc")
map_sfc <- function(feature_names, feature_type) {
  geoms <- map_sf(feature_type)
  registered_names <- get_feature_names(feature_type)
  matches <- match(feature_names, registered_names)

  if (any(is.na(matches))) {
    unmatched <- feature_names[is.na(matches)]
    cli::cli_abort(c("Feature names are not all present in the data registered for {feature_type}",
                     "i" = "These are missing: {head(unmatched, n = 3)}"))
  }
  sf::st_geometry(geoms[matches,])
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
