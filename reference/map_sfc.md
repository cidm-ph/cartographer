# Retrieve geometry of a single location.

Retrieve geometry of a single location.

## Usage

``` r
map_sfc(feature_names, feature_type)
```

## Arguments

- feature_names:

  Name of the feature(s) to retrieve. This must be an exact
  case-sensitive match, and aliases are not consulted.

- feature_type:

  Type of map feature. See
  [`feature_types()`](https://cidm-ph.github.io/cartographer/reference/feature_types.md)
  for a list of registered types.

## Value

The geometry as a `sfc` object.

## Examples

``` r
map_sfc("Ashe", "sf.nc")
#> Geometry set for 1 feature 
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -81.74107 ymin: 36.23436 xmax: -81.23989 ymax: 36.58965
#> Geodetic CRS:  NAD27
#> MULTIPOLYGON (((-81.47276 36.23436, -81.54084 3...
map_sfc(c("Craven", "Buncombe"), "sf.nc")
#> Geometry set for 2 features 
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -82.88111 ymin: 34.83043 xmax: -76.62562 ymax: 35.8164
#> Geodetic CRS:  NAD27
#> MULTIPOLYGON (((-76.89761 35.25157, -76.94743 3...
#> MULTIPOLYGON (((-82.2581 35.46373, -82.32288 35...
```
