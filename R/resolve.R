#' Guess the feature type if it was missing
#'
#' If `feature_type` is provided, this simply checks that the type has been
#' registered. If it is `NA`, however, an attempt it made to guess the
#' appropriate choice. This is done by comparing the example values provided
#' as `feature_names` with the names of all registered map datasets. If there
#' is an unambiguous match, that will be filled in.
#'
#' Note that this requires that any lazily-loaded datasets are loaded, so there
#' is a penalty to pay for the convenience.
#'
#' @param feature_type Type of map feature. See [feature_types()] for a list of
#'   registered types. If \code{NA}, the type is guessed based on the values in
#'   `feature_names`.
#' @param feature_names Character vector of feature names in the data. This can
#'   be a subset of the values.
#'
#' @returns The resolved feature type as a scalar character.
#' @export
#'
#' @examples
#' resolve_feature_type("sf.nc")
#' resolve_feature_type(NA, feature_names = c("ANSON", "Stanly"))
resolve_feature_type <- function (feature_type, feature_names) {
  if (is.null(feature_type)) return(NULL)
  if (is.na(feature_type)) feature_type <- guess_feature_type(feature_names)

  if (is.null(feature_type) || is.na(feature_type)) {
    cli::cli_abort("{.arg feature_type} must be provided")
  }
  types <- feature_types()
  if (!(feature_type %in% types)) {
    cli::cli_abort(c(
      paste0("Unknown {.arg feature_type} {.val ", feature_type, "}"),
      i = "Expected one of {types}"
    ))
  }

  feature_type
}

#' Canonicalise feature names accounting for aliases and character case
#'
#' Names are resolved by checking for the first match using:
#'   1. case sensitive match, then
#'   2. case sensitive match using aliases, then
#'   3. case insensitive match, then
#'   4. case insensitive match using aliases.
#'
#' @param feature_names Character vector of feature names in the data.
#' @param feature_type Type of map feature. See [feature_types()] for a list of
#'   registered types.
#'
#' @returns Character vector of the canonicalised names.
#' @export
#'
#' @examples
#' resolve_feature_names(c("LEE", "ansoN"), feature_type = "sf.nc")
resolve_feature_names <- function(feature_names, feature_type) {
  registered_names <- get_feature_names(feature_type)
  aliases <- map_aliases(feature_type)
  matches <- match_feature_names(feature_names, registered_names, aliases)

  unknown_features <- feature_names[is.na(matches)]
  if (length(unknown_features) > 0) {
    cli::cli_abort(c(
      paste0("{.field location} contains unexpected values"),
      "x" = "The unknown values are {unknown_features}.",
      "i" = "Expected {feature_type} names like {head(registered_names, n = 3)}.",
      "i" = "See feature_names('{feature_type}') for the full list."
    ))
  }

  registered_names[matches]
}

match_feature_names <- function(locations, feature_names, aliases) {
  if (length(locations) == 0) return(integer(0))

  mapply(
    function(...) {
      m <- c(...)
      m <- as.integer(m[!is.na(m)])
      if (length(m) > 0) m[[1]] else NA_integer_
    },
    match(locations, feature_names),
    match(aliases[locations], feature_names),
    match(tolower(locations), tolower(feature_names)),
    match(stats::setNames(aliases, tolower(names(aliases)))[tolower(locations)],
          feature_names),
    match(stats::setNames(tolower(aliases), tolower(names(aliases)))[tolower(locations)],
          tolower(feature_names))
  )
}

# FIXME this approach is forcing _all_ of the lazy loaded datasets
guess_feature_type <- function (feature_names) {
  feature_names <- unique(feature_names)
  types <- feature_types()

  found <- sapply(types, function (ty) {
    registered_names <- get_feature_names(ty)
    aliases <- map_aliases(ty)
    matches <- match_feature_names(feature_names, registered_names, aliases)
    sum(!is.na(matches))
  })

  if (length(feature_names) == 0) {
    cli::cli_abort(c("Unable to guess {.arg feature_type} from the data",
                     "x" = "{.field feature_names} is empty",
                     "i" = "Specify {.arg feature_type} explicitly"))
  } else if (all(found == 0)) {
    cli::cli_abort(c("Unable to guess {.arg feature_type} from the data",
                     "x" = "These features are not in any registered map: {head(feature_names, n = 3)}"),
                     "i" = "Register a new map or double check the correct data has been used")
  } else if (sum(found == max(found)) > 1) {
    cli::cli_abort(c("Unable to guess {.arg feature_type} from the data",
                     "x" = "The features match multiple registered maps: {names(found[found == max(found)])}",
                     "i" = "Specify {.arg feature_type} explicitly"))
  }
  names(found[which.max(found)])
}