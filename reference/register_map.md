# Register a new feature type

This adds a new feature type that can then be used by all the geoms in
this package. If registering from another package, this should occur in
the `.onLoad()` hook in the package.

## Usage

``` r
register_map(
  feature_type,
  data,
  feature_column,
  aliases = NULL,
  outline = NULL,
  lazy = TRUE
)
```

## Arguments

- feature_type:

  Name of the type. If registering from within a package, the suggested
  format is `"<package name>.<map name>"` to avoid clashes between
  packages.

- data:

  A simple feature data frame with the map data, or a function that
  returns a data frame. When `lazy` is `TRUE`, the value will not be
  evaluated until the data is first accessed.

- feature_column:

  Name of the column of `data` that contains the feature names.

- aliases:

  Optional named character vector or list that maps aliases to values
  that appear in the feature column. This allows abbreviations or
  alternative names to be supported.

- outline:

  Optional sf geometry containing just the outline of the map, or a
  function returning such a geometry. When `lazy` is `TRUE`, the value
  will not be evaluated until the data is first accessed.

- lazy:

  When `TRUE`, defer evaluation of `data` and `outline` until it is
  used.

## Value

No return value; this updates the global feature registry.

## Details

Registration supports delayed evaluation (lazy loading). This is
particularly useful for larger datasets, so that they are not loaded
into memory until they are accessed.

## See also

[`vignette("registering_maps")`](https://cidm-ph.github.io/cartographer/articles/registering_maps.md)

## Examples

``` r
# register a map of the states of Italy from rnaturalearth using the
# Italian names, and providing an outline of the country
register_map(
  "italy",
  data = rnaturalearth::ne_states(country = "italy", returnclass = "sf"),
  feature_column = "name_it",
  outline = rnaturalearth::ne_countries(country = "italy", returnclass = "sf", scale = "large")
)
```
