# List known feature names

This gives the list of feature names that are part of the specified map
data. The list includes any aliases defined when the map was registered.
Note that the `location` column matching is case insensitive (see
Details below).

## Usage

``` r
feature_names(feature_type)
```

## Arguments

- feature_type:

  Type of map feature. See
  [`feature_types()`](https://cidm-ph.github.io/cartographer/reference/feature_types.md)
  for a list of registered types.

## Value

Character vector of feature names.

## See also

[`register_map()`](https://cidm-ph.github.io/cartographer/reference/register_map.md)
and
[`resolve_feature_names()`](https://cidm-ph.github.io/cartographer/reference/resolve_feature_names.md)

## Examples

``` r
head(feature_names("sf.nc"))
#> [1] "Ashe"        "Alleghany"   "Surry"       "Currituck"   "Northampton"
#> [6] "Hertford"   
```
