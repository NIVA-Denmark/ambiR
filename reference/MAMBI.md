# Calculates M-AMBI, the multivariate AZTI Marine Biotic Index

Calculates M-AMBI the multivariate AMBI index, based on the three
separate species diversity metrics:

- AMBI index `AMBI`.

- Shannon diversity index `H'`

- Species richness `S`.

*"AMBI, richness and diversity, combined with the use, in a further
development, of factor analysis together with discriminant analysis, is
presented as an objective tool (named here M-AMBI) in assessing
ecological quality status"* [Muxika et al.,
2007](https://niva-denmark.github.io/ambiR/reference/%5Cdoi%7B10.1016/j.marpolbul.2006.05.025%7D)

## Usage

``` r
MAMBI(
  df,
  by = NULL,
  var_H = "H",
  var_S = "S",
  var_AMBI = "AMBI",
  limits_AMBI = c(bad = 6, high = 0),
  limits_H = c(bad = 0, high = NA),
  limits_S = c(bad = 0, high = NA),
  bounds = c(PB = 0.2, MP = 0.39, GM = 0.53, HG = 0.77)
)
```

## Arguments

- df:

  a dataframe of diversity metrics

- by:

  a vector of column names found in `df` by which calculations should be
  grouped *e.g.* `c("station")`. If grouping columns are specified, then
  the mean values of the 3 metrics will be calculated within each group
  before calculating `M-AMBI` (default `NULL`)

- var_H:

  name of the column in `df` containing `H'` Shannon species diversity
  (default `"H"`)

- var_S:

  name of the column in `df` containing `S` species richness (default
  `"S"`)

- var_AMBI:

  name of the column in `df` containing `AMBI` index (default `"AMBI"`)

- limits_AMBI:

  named vector with length 2, specifying the values of `AMBI`
  corresponding to *(i)* worst possible condition (`"bad"`) where
  `M-AMBI` and `EQR` are equal to 0.0 and *(ii)* the best possible
  condition (`"high"`) where `M-AMBI` and `EQR` are equal to 1.0.
  Default `c("bad" = 6, "high" = 0)`.

- limits_H:

  named vector with length 2, specifying the values of `H'`
  corresponding to *(i)* worst possible condition (`"bad"`) where
  `M-AMBI` and `EQR` are equal to 0.0 and *(ii)* the best possible
  condition (`"high"`) where `M-AMBI` and `EQR` are equal to 1.0.
  Default `c("bad" = 0, "high" = NA)`. If the `"bad"` value is `NA` then
  the lowest value occurring in `df` and if `"high"` is `NA` then the
  highest value will be used.

- limits_S:

  named vector with length 2, specifying the values of `S` corresponding
  to *(i)* worst possible condition (`"bad"`) where `M-AMBI` and `EQR`
  are equal to 0.0 and *(ii)* the best possible condition (`"high"`)
  where `M-AMBI` and `EQR` are equal to 1.0. Default
  `c("bad" = 0, "high" = NA)`. If the `"bad"` value is `NA` then the
  lowest value occurring in `df` and if `"high"` is `NA` then the
  highest value will be used.

- bounds:

  A named vector (*length 4*) of EQR boundary values used to normalise
  M-AMBI to EQR values where the boundary between *Good* and *Moderate*
  ecological status is 0.6. They specify the values of M-AMBI
  corresponding to the boundaries between *(i)* *Poor* and *Bad* status
  (`"PB"`), *(ii)* *Moderate* and *Poor* status (`"MP"`), *(iii)* *Good*
  and *Moderate* status (`"GM"`), and *(iv)* *High* and *Good* status
  (`"HG"`). Default
  `c("PB" = 0.2, "MP" = 0.39, "GM" = 0.53, "HG" = 0.77)`

## Value

a dataframe containing results of the M-AMBI index calculations. For
each unique combination of `by` variables, the following values are
calculated:

- `M-AMBI` : the M-AMBI index value

- `X`,`Y`,`Z` : factor scores giving coordinates in the new factor
  space.

If no `by` variables are specified (`by = NULL`), then `M-AMBI` will be
calculated for each row in `df`.

In addition, the dataframe returned contains 2 *extra* rows. These
contain the limits applied for each of the metrics, corresponding to
`"bad"` (`M-AMBI` = 0.0) and `"high"` (`M-AMBI` = 1.0), as specified in
the arguments `limits_AMBI`, `limits_H`, `limits_S` or taken from data.

## Details

The input dataframe `df` should contain the three metrics `AMBI`, `H'`
and `S`, identified by the column names `var_AMBI` (default `"AMBI"`),
`var_H` (default `"H"`) and `var_S` (default `"S"`).

If any of these three metrics is not found in the input data, then the
function will return an error.

`AMBI` is calculated using the
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function. `H'` can be calculated using the
[`Hdash()`](https://niva-denmark.github.io/ambiR/reference/Hdash.md)
function but it is also included as additional output from
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md) when
called with the non-default argument `H = TRUE`. `S` is an output from
both functions
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md) and
[`Hdash()`](https://niva-denmark.github.io/ambiR/reference/Hdash.md).

This means that the input to `MAMBI()` can be generated from species
count data using only using the
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function.

## See also

[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md) which
calculates the indices required as input for `MAMBI()`.

## Examples

``` r
df <- data.frame(station = c(1, 1, 1, 2, 2, 2, 3, 3),
                 replicates = c("a", "b", "c", "a", "b", "c", "a", "b"),
                 AMBI = c(1.8, 1.5, 1.125, 1.875, 2.133, 1.655, 3.5, 4.75),
                 H = c(1.055, 0.796, 0.562, 2.072, 2.333, 1.789, 1.561, 1.303),
                 S = c(3, 3, 2, 12, 12, 10, 5, 6))

MAMBI(df, by = c("station"))
#> # A tibble: 5 × 11
#>   station Bounds  AMBI     H     S      x      y        z MAMBI Status   EQR
#>     <dbl> <chr>  <dbl> <dbl> <dbl>  <dbl>  <dbl>    <dbl> <dbl> <chr>  <dbl>
#> 1       1 NA      1.48 0.804  2.67  0.863 -0.248  0.00897 0.464 Mod    0.439
#> 2       2 NA      1.89 2.06  11.3  -2.11  -0.486  0.00359 0.893 High   0.907
#> 3       3 NA      4.12 1.43   5.5   0.346  0.449  0.0334  0.497 Mod    0.456
#> 4      NA Bad     6    0      0     3.53   1.38  -0.0519  0     NA     0    
#> 5      NA High    0    2.06  11.3  -2.63  -1.09   0.00597 1     NA     1    

```
