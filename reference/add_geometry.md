# Convert input data frame into a spatial data frame

Convert input data frame into a spatial data frame

## Usage

``` r
add_geometry(x, location, feature_type = NA, geom_name = "geometry")
```

## Arguments

- x:

  Data frame with a feature name column.

- location:

  Feature names (tidy evaluation).

- feature_type:

  The registered map corresponding to values in `location`. If NA (the
  default), the type is guessed from the values in `location`.

- geom_name:

  Name for the new column to contain the geometry.

## Value

A spatial data frame containing all of the columns from the input data
frame.

## Examples

``` r
add_geometry(nc_type_example_2, county, feature_type = "sf.nc")
#> Simple feature collection with 200 features and 2 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -82.74389 ymin: 35.14903 xmax: -76.69376 ymax: 36.24614
#> Geodetic CRS:  NAD27
#> First 10 features:
#>       county type                       geometry
#> 1     MARTIN    A MULTIPOLYGON (((-77.17846 3...
#> 2   ALAMANCE    B MULTIPOLYGON (((-79.24619 3...
#> 3     BERTIE    A MULTIPOLYGON (((-76.78307 3...
#> 4    CHATHAM    B MULTIPOLYGON (((-79.55536 3...
#> 5    CHATHAM    B MULTIPOLYGON (((-79.55536 3...
#> 6  HENDERSON    B MULTIPOLYGON (((-82.57003 3...
#> 7     GASTON    B MULTIPOLYGON (((-81.32282 3...
#> 8     GASTON    B MULTIPOLYGON (((-81.32282 3...
#> 9    LINCOLN    B MULTIPOLYGON (((-80.95677 3...
#> 10 HENDERSON    A MULTIPOLYGON (((-82.57003 3...
```
