# Retrieve a map outline registered with cartographer.

Retrieve a map outline registered with cartographer.

## Usage

``` r
map_outline(feature_type)
```

## Arguments

- feature_type:

  Type of map feature. See
  [`feature_types()`](https://cidm-ph.github.io/cartographer/reference/feature_types.md)
  for a list of registered types.

## Value

The map outline that was registered under `feature_type`. Note that the
outline is optional, so this will return `NULL` if none was registered.

## Examples

``` r
map_outline("sf.nc")
#> NULL
```
