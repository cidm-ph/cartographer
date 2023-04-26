#' Turn Place Names into Map Data
#'
#' Cartographer is a framework for easily matching spatial data when
#' you have a list of standardised place names. You might have a data frame
#' that came from a spreadsheet tracking some data by suburb or state. This
#' package can convert it into a spatial data frame ready for plotting. The
#' actual map data is provided by other packages (or your own code) that
#' register the data with cartographer.
#'
#' @docType package
"_PACKAGE"

#' @useDynLib cartographer, .registration = TRUE, .fixes = "C_"
NULL
