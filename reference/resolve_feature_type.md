# Guess the feature type if it was missing

If `feature_type` is provided, this simply checks that the type has been
registered. If it is `NA`, however, an attempt it made to guess the
appropriate choice. This is done by comparing the example values
provided as `feature_names` with the names of all registered map
datasets. If there is an unambiguous match, that will be filled in.

## Usage

``` r
resolve_feature_type(feature_type, feature_names)
```

## Arguments

- feature_type:

  Type of map feature. See
  [`feature_types()`](https://cidm-ph.github.io/cartographer/reference/feature_types.md)
  for a list of registered types. If `NA`, the type is guessed based on
  the values in `feature_names`.

- feature_names:

  Character vector of feature names in the data. This can be a subset of
  the values.

## Value

The resolved feature type as a scalar character.

## Details

Cartographer lazy loads map data for registered maps. In order to
compare the example `feature_names` with registered maps, it might be
necessary to force some of these datasets to load. To minimise the
impact, any maps that have already been loaded are checked first. Other
maps are then loaded one at a time until any matches are found.
Consequently, the result returned by this function is not deterministic.

In the worst case where none of the registered maps matches, all of them
will be loaded. This might take several seconds and occupy some memory,
depending on which maps are registered. If a match is found, however, it
will be found quickly on subsequent calls since the data will have
already been loaded.

The best way to avoid these issues is to explicitly specify the
`feature_type`.

## Examples

``` r
resolve_feature_type("sf.nc")
#> [1] "sf.nc"
resolve_feature_type(NA, feature_names = c("ANSON", "Stanly"))
#> [1] "sf.nc"
```
