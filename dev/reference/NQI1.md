# Calculates NQI1, the Norwegian Quality Index

`NQI1()` calculates the Norwegian Quality Index, NQI1 [(Rygg,
2006)](#references)

The NQI1 is based on AMBI and can only be calculated after first
calculating *AMBI*, the AZTI Marine Biotic Index, using output from the
function
[`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md).

NQI1 is the only Norwegian benthic fauna index which is inter-calibrated
with all countries belonging to the North East Atlantic Geographical
Intercalibration Group (NEAGIG)[(Borgersen et al, 2019)](#references) .

## Usage

``` r
NQI1(AMBI, N, S)
```

## Arguments

- AMBI:

  AMBI, the AZTI Marine Biotic Index, calculated using
  [`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md)

- N:

  number of individuals - returned by both
  [`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md)
  and
  [`Hdash()`](https://niva-denmark.github.io/ambiR/dev/reference/Hdash.md)

- S:

  number of species - returned by both
  [`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md)
  and
  [`Hdash()`](https://niva-denmark.github.io/ambiR/dev/reference/Hdash.md)

## Value

`NQI1` index value

## Details

While
[`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md)
takes a dataframe of observations as an argument, `NQI1()` does *not*.
Instead, similarly to the DKI functions, it takes values of the input
parameters, either single values or as vectors.

To calculate NQI1 for a dataframe of `AMBI` values, it could be called
from e.g. within a
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
function call. See the examples below.

## References

Rygg, B. (2006) Developing indices for quality-status classification of
marine soft-bottom fauna in Norway. (Report No. 5208) Norwegian
Institute for Water Research (NIVA). 33 pp.
<https://hdl.handle.net/11250/213219> Borgersen, G., Trannum, H.C.,
Gundersen, H., Vedal, J. (2019). Oppdatering av bløtbunnsartenes
sensitivitetsverdier (Report No. 7366). Norsk institutt for
vannforskning (NIVA). <https://hdl.handle.net/11250/2600903>

## See also

For more details, see\`vignette("other-indices").

## Examples

``` r

# Simple example

NQI1(AMBI = 1.61, N = 25, S = 6)
#> [1] 0.6215256


# ------ Example workflow for calculating NQI1 from species counts ----

# calculate AMBI index using Norwegian example data

df <- AMBI(test_data_NO,
               by = "station",
               var_rep = "sample",
               var_species = "species",
               var_count = "count",
               quiet = TRUE)[["AMBI"]]

# show AMBI results
df
#> # A tibble: 2 × 13
#>   station        AMBI AMBI_SD     H     S    fNA     N     I    II    III     IV
#>   <chr>         <dbl>   <dbl> <dbl> <int>  <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 Ærøy (U10)     1.26  0.154   4.87    92 0.0388   645 0.348 0.535 0.0677 0.0452
#> 2 Ærøydypet (U…  2.29  0.0209  4.69    57 0.0345   261 0.111 0.425 0.294  0.171 
#> # ℹ 2 more variables: V <dbl>, Disturbance <chr>

# calculate NQI1 from AMBI results
df <- dplyr::mutate(df, NQI1 = NQI1(AMBI, N, S))
dplyr::select(df, AMBI, N, S, NQI1)
#> # A tibble: 2 × 4
#>    AMBI     N     S  NQI1
#>   <dbl> <dbl> <int> <dbl>
#> 1  1.26   645    92 0.855
#> 2  2.29   261    57 0.764
```
