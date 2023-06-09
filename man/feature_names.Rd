% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cartographer-global.R
\name{feature_names}
\alias{feature_names}
\title{List known feature names}
\usage{
feature_names(feature_type)
}
\arguments{
\item{feature_type}{Type of map feature. See \code{\link[=feature_types]{feature_types()}} for a list of
registered types.}
}
\value{
Character vector of feature names.
}
\description{
This gives the list of feature names that are part of the specified map data.
The list includes any aliases defined when the map was registered. Note that
the \code{location} column matching is case insensitive (see Details below).
}
\examples{
head(feature_names("sf.nc"))
}
\seealso{
\code{\link[=register_map]{register_map()}} and \code{\link[=resolve_feature_names]{resolve_feature_names()}}
}
