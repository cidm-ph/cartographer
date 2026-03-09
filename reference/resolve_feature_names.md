# Canonicalise feature names accounting for aliases and character case

Names are resolved by checking for the first match using:

1.  case sensitive match, then

2.  case sensitive match using aliases, then

3.  case insensitive match, then

4.  case insensitive match using aliases.

## Usage

``` r
resolve_feature_names(feature_names, feature_type, unmatched = "error")
```

## Arguments

- feature_names:

  Character vector of feature names in the data.

- feature_type:

  Type of map feature. See
  [`feature_types()`](https://cidm-ph.github.io/cartographer/reference/feature_types.md)
  for a list of registered types.

- unmatched:

  Controls behaviour when `feature_names` contains values that do not
  match registered feature names. Possible values are `"error"` to throw
  an error or `"pass"` to return the original values unaltered.

## Value

Character vector of the canonicalised names.

## Examples

``` r
resolve_feature_names(c("LEE", "ansoN"), feature_type = "sf.nc")
#> [1] "Lee"   "Anson"
resolve_feature_names(c("LEE", "ansoNe"), feature_type = "sf.nc", unmatched = "pass")
#> [1] "Lee"    "ansoNe"
```
