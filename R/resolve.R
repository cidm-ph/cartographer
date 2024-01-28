#' Guess the feature type if it was missing
#'
#' If `feature_type` is provided, this simply checks that the type has been
#' registered. If it is `NA`, however, an attempt it made to guess the
#' appropriate choice. This is done by comparing the example values provided
#' as `feature_names` with the names of all registered map datasets. If there
#' is an unambiguous match, that will be filled in.
#'
#' Cartographer lazy loads map data for registered maps. In order to compare
#' the example `feature_names` with registered maps, it might be necessary
#' to force some of these datasets to load. To minimise the impact, any maps
#' that have already been loaded are checked first. Other maps are then
#' loaded one at a time until any matches are found. Consequently, the result
#' returned by this function is not deterministic.
#'
#' In the worst case where none of the registered maps matches, all of them
#' will be loaded. This might take several seconds and occupy some memory,
#' depending on which maps are registered. If a match is found, however, it
#' will be found quickly on subsequent calls since the data will have
#' already been loaded.
#'
#' The best way to avoid these issues is to explicitly specify the
#' `feature_type`.
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
resolve_feature_type <- function(feature_type, feature_names) {
  if (is.null(feature_type)) {
    return(NULL)
  }
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
#' @param unmatched Controls behaviour when `feature_names` contains values
#'   that do not match registered feature names. Possible values are
#'   `"error"` to throw an error or
#'   `"pass"` to return the original values unaltered.
#'
#' @returns Character vector of the canonicalised names.
#' @export
#'
#' @examples
#' resolve_feature_names(c("LEE", "ansoN"), feature_type = "sf.nc")
#' resolve_feature_names(c("LEE", "ansoNe"), feature_type = "sf.nc", unmatched = "pass")
resolve_feature_names <- function(feature_names, feature_type,
                                  unmatched = "error") {
  registered_names <- get_feature_names(feature_type)
  aliases <- map_aliases(feature_type)
  matches <- match_feature_names(feature_names, registered_names, aliases)

  unmatched <- rlang::arg_match0(unmatched, c("error", "pass"))
  switch(unmatched,
    error = {
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
    },
    pass = dplyr::if_else(is.na(matches),
      feature_names,
      registered_names[matches]
    )
  )
}

match_feature_names <- function(locations, feature_names, aliases) {
  if (length(locations) == 0) {
    return(integer(0))
  }

  mapply(
    function(...) {
      m <- c(...)
      m <- as.integer(m[!is.na(m)])
      if (length(m) > 0) m[[1]] else NA_integer_
    },
    match(locations, feature_names),
    match(aliases[locations], feature_names),
    match(tolower(locations), tolower(feature_names)),
    match(
      stats::setNames(aliases, tolower(names(aliases)))[tolower(locations)],
      feature_names
    ),
    match(
      stats::setNames(tolower(aliases), tolower(names(aliases)))[tolower(locations)],
      tolower(feature_names)
    )
  )
}

guess_feature_type <- function(feature_names) {
  feature_names <- unique(feature_names)
  if (length(feature_names) == 0) {
    cli::cli_abort(c(
      "Unable to guess {.arg feature_type} from the data",
      "x" = "{.field feature_names} is empty",
      "i" = "Specify {.arg feature_type} explicitly"
    ))
  }

  types <- feature_types()
  was_forced <- sapply(types, promise_was_forced)

  # first skip any types that haven't already been lazy loaded
  found <- sapply(types[was_forced], function(ty) {
    registered_names <- get_feature_names(ty)
    aliases <- map_aliases(ty)
    matches <- match_feature_names(feature_names, registered_names, aliases)
    sum(!is.na(matches))
  })
  if (any(found != 0)) {
    if (sum(found == max(found)) > 1) {
      cli::cli_abort(c(
        "Unable to guess {.arg feature_type} from the data",
        "x" = "The features match multiple registered maps: {names(found[found == max(found)])}",
        "i" = "Specify {.arg feature_type} explicitly"
      ))
    }
    return(names(found[which.max(found)]))
  }

  guessed_ty <- NULL
  errors <- list()

  # force loading of maps where this is possible without errors
  for (ty in types[!was_forced]) {
    registered_names <- tryCatch(get_feature_names(ty), error = function(cnd) cnd)
    if (rlang::is_error(registered_names)) {
      errors[[ty]] <- registered_names$message
      next
    }

    aliases <- map_aliases(ty)
    matches <- match_feature_names(feature_names, registered_names, aliases)

    # don't look for the best match: just return the first to avoid loading more packages
    if (any(!is.na(matches))) {
      guessed_ty <- ty
      break
    }
  }

  if (length(errors) > 0) {
    details <- paste0("{.field ", names(errors), "}: ", unname(errors))
    cli::cli_inform(c(
      "While guessing {.arg feature_type}, cartographer skipped {length(errors)} maps that could not be loaded",
      stats::setNames(details, rep("*", length(errors))),
      "i" = "Specify {.arg feature_type} explicitly to avoid this message"
    ))
  }

  if (is.null(guessed_ty)) {
    cli::cli_abort(c(
      "Cartographer was unable to guess {.arg feature_type} from the data",
      "x" = "These features are not in any registered map: {head(feature_names, n = 3)}",
      "i" = "Register a new map or double check the correct data has been used"
    ))
  } else {
    cli::cli_inform(c(
      "Cartographer guessed {.arg feature_type} to be '{ty}'",
      "i" = "Specify {.arg feature_type} explicitly to avoid this message"
    ))
    ty
  }
}
