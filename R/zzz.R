.onLoad <- function(libname, pkgname) {
  register_map("sf.nc",
    function() sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE),
    feature_column = "NAME")

  register_map("maps.world",
    function() sf::st_as_sf(maps::map('world', plot = FALSE, fill = TRUE)),
    feature_column = "ID")

  register_map("maps.italy",
    function() sf::st_as_sf(maps::map('italy', plot = FALSE, fill = TRUE)),
    feature_column = "ID")

  register_map("maps.france",
    function() sf::st_as_sf(maps::map('france', plot = FALSE, fill = TRUE)),
    feature_column = "ID")

  register_map("maps.nz",
    function() sf::st_as_sf(maps::map('nz', plot = FALSE, fill = TRUE)),
    feature_column = "ID")

  register_map("maps.state",
    function() sf::st_as_sf(maps::map('state', plot = FALSE, fill = TRUE)),
    feature_column = "ID")

  register_map("maps.lakes",
    function() sf::st_as_sf(maps::map('lakes', plot = FALSE, fill = TRUE)),
    feature_column = "ID")
}
