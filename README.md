
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cartographer

<!-- badges: start -->

[![cartographer status
badge](https://cidm-ph.r-universe.dev/badges/cartographer)](https://cidm-ph.r-universe.dev)
<!-- badges: end -->

If you have a list of place/region names (for example as a column in a
data frame) and you’d like to turn that into spatial data,
`{cartographer}` can help. There are 2 steps:

1.  Register the spatial data with `{cartographer}` using
    `register_map()`, or load a package that already did that for you.
2.  Use `add_geometry()` to turn your ordinary data frame into a spatial
    one.

`{cartographer}` complains if it doesn’t recognise any of the place
names, and can handle aliases, for example abbreviated state names.

See `vignette("cartographer")` for examples, and `{ggautomap}` for some
handy ggplot helpers that pull map data using `{cartographer}`.

## Installation

You can install cartographer like so:

``` r
options(repos = c(
  cidmph = 'https://cidm-ph.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
  
install.packages('cartographer')
```

## Map data

Some packages provide data that works with `{cartographer}`:

- `{maps}` - some dated example maps of the world and several countries.
- `{rnaturalearth}` - countries and states (where available).
- `{nswgeo}` - maps of New South Wales, Australia.

Alternatively, you can register your own data using `register_map()`
(see `vignette("registering_maps")`).
