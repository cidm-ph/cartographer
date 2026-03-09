# cartographer

If you have a list of place/region names (for example as a column in a
data frame) and you’d like to turn that into spatial data,
[cartographer](https://github.com/cidm-ph/cartographer) can help. There
are 2 steps:

1.  Register the spatial data with
    [cartographer](https://github.com/cidm-ph/cartographer) using
    [`register_map()`](https://cidm-ph.github.io/cartographer/reference/register_map.md),
    or load a package that already did that for you.
2.  Use
    [`add_geometry()`](https://cidm-ph.github.io/cartographer/reference/add_geometry.md)
    to turn your ordinary data frame into a spatial one.

Cartographer will be most useful when you are working regularly with
data about the same places. You can do the work once to curate your
geospatial data, and thereafter you can use cartographer to quickly jump
from place names to map data ready to analyse or visualise.

See
[`vignette("cartographer")`](https://cidm-ph.github.io/cartographer/articles/cartographer.md)
for examples, and [ggautomap](https://github.com/cidm-ph/ggautomap) for
some handy ggplot helpers that pull map data using
[cartographer](https://github.com/cidm-ph/cartographer).

## Installation

You can install cartographer like so:

``` r
# CRAN release
install.packages('cartographer')

# development version
install.packages('cartographer', repos = c('https://cidm-ph.r-universe.dev', 'https://cloud.r-project.org'))
```

## Map data

Some packages provide data that works with
[cartographer](https://github.com/cidm-ph/cartographer):

- [maps](https://github.com/adeckmyn/maps) - some dated example maps of
  the world and several countries.
- [rnaturalearth](https://docs.ropensci.org/rnaturalearth/) - countries
  and states (where available).
- [nswgeo](https://github.com/cidm-ph/nswgeo) - maps of New South Wales,
  Australia.

Alternatively, you can register your own data using
[`register_map()`](https://cidm-ph.github.io/cartographer/reference/register_map.md)
(see
[`vignette("registering_maps")`](https://cidm-ph.github.io/cartographer/articles/registering_maps.md)).
