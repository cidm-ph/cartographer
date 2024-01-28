.onLoad <- function(libname, pkgname) {
  register_map("sf.nc",
    data = sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE),
    feature_column = "NAME"
  )

  register_map("maps.world",
    data = {
      if (!requireNamespace("maps", quietly = TRUE)) {
        stop("maps.world requires the 'maps' package")
      }
      sf::st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
    },
    feature_column = "ID"
  )

  register_map("maps.italy",
    data = {
      if (!requireNamespace("maps", quietly = TRUE)) {
        stop("maps.italy requires the 'maps' package")
      }
      sf::st_as_sf(maps::map("italy", plot = FALSE, fill = TRUE))
    },
    feature_column = "ID"
  )

  register_map("maps.france",
    data = {
      if (!requireNamespace("maps", quietly = TRUE)) {
        stop("maps.france requires the 'maps' package")
      }
      sf::st_as_sf(maps::map("france", plot = FALSE, fill = TRUE))
    },
    feature_column = "ID"
  )

  register_map("maps.nz",
    data = {
      if (!requireNamespace("maps", quietly = TRUE)) {
        stop("maps.nz requires the 'maps' package")
      }
      sf::st_as_sf(maps::map("nz", plot = FALSE, fill = TRUE))
    },
    feature_column = "ID"
  )

  register_map("maps.state",
    data = {
      if (!requireNamespace("maps", quietly = TRUE)) {
        stop("maps.state requires the 'maps' package")
      }
      sf::st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))
    },
    feature_column = "ID"
  )

  register_map("maps.lakes",
    data = {
      if (!requireNamespace("maps", quietly = TRUE)) {
        stop("maps.lakes requires the 'maps' package")
      }
      sf::st_as_sf(maps::map("lakes", plot = FALSE, fill = TRUE))
    },
    feature_column = "ID"
  )

  register_map("rnaturalearth.countries",
    data = {
      if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
        stop("rnaturalearth.countries requires the 'rnaturalearth' package")
      }
      rnaturalearth::ne_countries(returnclass = "sf")
    },
    feature_column = "name_en"
  )

  register_map("rnaturalearth.countries_hires",
    data = {
      if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
        stop("rnaturalearth.countries_hires requires the 'rnaturalearth' package")
      }
      if (!requireNamespace("rnaturalearthhires", quietly = TRUE)) {
        stop("rnaturalearth.countries_hires requires the 'rnaturalearthhires' package")
      }
      rnaturalearth::ne_countries(returnclass = "sf", scale = "large")
    },
    feature_column = "name_en"
  )

  register_map("rnaturalearth.australia",
    data = {
      if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
        stop("rnaturalearth.australia requires the 'rnaturalearth' package")
      }
      if (!requireNamespace("rnaturalearthhires", quietly = TRUE)) {
        stop("rnaturalearth.australia requires the 'rnaturalearthhires' package")
      }
      rnaturalearth::ne_states(country = "Australia", returnclass = "sf")
    },
    outline = rnaturalearth::ne_countries(
      country = "Australia", scale = "large", returnclass = "sf"
    ),
    feature_column = "name_en"
  )
}
