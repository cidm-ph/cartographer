# Example datasets with a feature name column and random data

This dataset contains random data compatible with the `sf.nc` example
map data for illustrating cartographer's features. `nc_type_example_1`
contains a deliberate error in the county name for a single row, whereas
`nc_type_example_2` contains correct data.

## Usage

``` r
nc_type_example_1

nc_type_example_2
```

## Format

Objects of class `data.frame` with 50 and 200 rows respectively, and 2
columns:

- county:

  Feature names that match the NAME field of the nc dataset

- type:

  Arbitrary categorical data
