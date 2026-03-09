# Registering map data with 'cartographer'

``` r
library(cartographer)
```

If you are often working with spatial data concerning a specific region,
it might make sense to bundle up the map data along with its
registration as an R package. This is true even if the data is only for
internal use.

To get started, you can use `usethis::create_package()` to generate the
files you need for a new package.

## Obtaining the data

Start by calling `usethis::use_data_raw("my_map_name")` to create an R
script where you can prepare your data. This helps you remember what you
did in case you need to revisit the dataset later.

You’ll need to download the map data that you’ll be using. There might
be shapefiles published by a local jurisdiction, or you could look to
packages like [rnaturalearth](https://docs.ropensci.org/rnaturalearth/)
that can provide general-purpose map data. Either way, you want to end
up with an [sf](https://r-spatial.github.io/sf/) data frame.
[`sf::read_sf()`](https://r-spatial.github.io/sf/reference/st_read.html)
can read many common map data formats, and
[`sf::st_as_sf()`](https://r-spatial.github.io/sf/reference/st_as_sf.html)
can convert other types of spatial data (including a data frame with
latitude and longitude columns) into the right format.

Once you have the data ready, call `usethis::use_data("my_map_name")` to
add it to your package.

## Registering the map

Your package will need to inform
[cartographer](https://github.com/cidm-ph/cartographer) of the data by
calling
[`register_map()`](https://cidm-ph.github.io/cartographer/reference/register_map.md).
This needs to happen after your package is loaded, so the
[`base::.onLoad()`](https://rdrr.io/r/base/ns-hooks.html) hook is the
appropriate place. This is often placed in a file named `"zzz.R"` so
that it comes last alphabetically, but this is not a requirement. Use
`usethis::use_r("zzz")` to create the file in your package.

This example registers a map that is returned by
[rnaturalearth](https://docs.ropensci.org/rnaturalearth/) without any
additional processing as described above:

``` r
# in R/zzz.R
.onLoad <- function(libname, pkgname) {
  cartographer::register_map(
    "my_package.uk",
    data = rnaturalearth::ne_states(country = "united kingdom", returnclass = "sf"),
    feature_column = "name_en",
    outline = rnaturalearth::ne_countries(
      country = "united kingdom", returnclass = "sf", scale = "large"
    )
  )
}
```

The registration should at least include the map data and the name of
the column that labels the features. It can also contain an alias
mapping if there are alternative names or abbreviations for places that
would plausibly appear in datasets.

## Publishing your package

At this point, you could install your package with `devtools::install()`
and use it in other scripts on your machine.

If you want to publish your package, you’ll need to do some extra work
to clean it up. For a general introduction to R packaging, see [the R
packaging book](https://r-pkgs.org/). The [chapter on packaging
data](https://r-pkgs.org/data.html) in particular contains many relevant
hints. You’ll need to be careful that any data you’re using is licensed
in a way that lets you share it, and that you properly acknowledge the
copyright holder.

See [nswgeo](https://github.com/cidm-ph/nswgeo) for an example of a
package that bundles some map data and relevant helpers, registering the
maps with [cartographer](https://github.com/cidm-ph/cartographer).

## Reducing file size

Spatial datasets can often be quite large if they contain high
resolution data. This can especially be a problem if attempting to
commit the data to git or publish your package to CRAN (where 1 MB is
the soft limit for the total compressed size of packages).

Consider removing extra columns from the spatial dataset so that only
the geometry column and the name column remain.

A useful pattern to reduce the size is to simplify the geometry to a
specified resolution:

``` r
# Preserve the original coordinate reference system.
crs_orig <- sf::st_crs(high_res_sf_data_frame)

# Convert to a more suitable CRS for manipulation. Note that the lat_ts argument
# here is the "latitude of true scale", i.e. the latitude at which scale will be
# the least distorted. Adjust this based on your data.
crs_working <- sf::st_crs("+proj=eqc +lat_ts=34 units=m")

# Choose a resolution: features smaller than this scale will be lost.
tolerance_m <- 1000L

low_res <- high_res_sf_data_frame |>
  sf::st_transform(crs_working) |>
  sf::st_simplify(dTolerance = tolerance_m) |>
  sf::st_transform(crs_orig)

# Compare the size after reducing the resolution:
object.size(high_res_sf_data_frame)
object.size(low_res)
```

See the documentation for the [equidistant
cylindrical](https://proj.org/operations/projections/eqc.html)
projection for details of its configuration.

You may also wish to remove holes in features:

``` r
new_geom <- geom |>
  sf::st_transform(crs_working) |>
  sf::st_union() |>
  nngeo::st_remove_holes() |>
  sf::st_make_valid()
```
