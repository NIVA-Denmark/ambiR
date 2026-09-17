# Calculates DKI (*v1*), the Danish Quality Index

`DKI()` calculates the original version of the Danish quality index DKI
[(Carstensen et al., 2014)](#references)

The DKI is based on AMBI and can only be calculated after first
calculating *AMBI*, the AZTI Marine Biotic Index, and *H'*, the Shannon
diversity index. Both indices are included in output from the function
[`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md).

The function uses an estimated maximum possible value of H' in Danish
waters (`H_max`) as a reference value to normalise DKI. If this value is
not specified as an argument, the default value is used (`5.0`) [(Borja
et al., 2007)](#references)

## Usage

``` r
DKI(AMBI, H, N, S, H_max = 5)
```

## Arguments

- AMBI:

  AMBI, the AZTI Marine Biotic Index, calculated using
  [`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md)

- H:

  H', the Shannon diversity index, calculated using
  [`Hdash()`](https://niva-denmark.github.io/ambiR/dev/reference/Hdash.md)

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

- H_max:

  maximum H' used to normalise AMBI, *default 5*

## Value

`DKI` index value

## Details

The
[`AMBI()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI.md)
and
[`Hdash()`](https://niva-denmark.github.io/ambiR/dev/reference/Hdash.md)
functions take a dataframe of observations as an argument. The DKI
functions,
[`DKI2()`](https://niva-denmark.github.io/ambiR/dev/reference/DKI2.md)
and `DKI()`, do *not* take a dataframe as an argument. Instead they take
values of the input parameters, either single values or as vectors.

To calculate DKI for a dataframe of `AMBI` values, it could be called
from e.g. within a
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)
function call. See the examples below.

## References

Borja, A., Josefson, A., Miles, A., Muxika, I., Olsgard, F., Phillips,
G., Rodriguez, J., Rygg, B. (2007). An Approach to the Intercalibration
of Benthic Ecological Status Assessment in the North Atlantic Ecoregion,
According to the European Water Framework Directive. *Marine Pollution
Bulletin*, 55(1-6), 42-52.
[doi:10.1016/j.marpolbul.2006.08.018](https://doi.org/10.1016/j.marpolbul.2006.08.018)
.

Carstensen, J., Krause-Jensen, D., Josefson, A. (2014). "Development and
testing of tools for intercalibration of phytoplankton, macrovegetation
and benthic fauna in Danish coastal areas." Aarhus University, DCE –
Danish Centre for Environment and Energy, 85 pp. *Scientific Report from
DCE – Danish Centre for Environment and Energy* No. 93.
<https://dce2.au.dk/pub/SR93.pdf>

## See also

DKI v1 has been superseded by
[`DKI2()`](https://niva-denmark.github.io/ambiR/dev/reference/DKI2.md) a
salinity-normalised version of DKI. For more details,
see\`vignette("other-indices").

## Examples

``` r

# Simple example

DKI(AMBI = 1.61, H = 2.36, N = 25, S = 6)
#> [1] 0.55683


# ------ Example workflow for calculating DKI from species counts ----

# calculate AMBI index
df <- AMBI(test_data_DK, by = c("station"), var_rep="sample")[["AMBI"]]
#> ℹ 7 species names were not recognised:
#> 1. Bivalvia indet.
#> 2. Enteropneusta indet.
#> 3. Gastropoda indet.
#> 4. Holothuroidea indet.
#> 5. Hydrozoa indet.
#> 6. Nemertini indet.
#> 7. Terebellida indet.

# modify names which were not recognized by AMBI() and recalculate
df_obs <- dplyr::mutate(test_data_DK, species = gsub(" indet\\.", "", species))
df <- ambiR::AMBI(df_obs, by = c("station"), var_rep="sample")[["AMBI"]]
#> ℹ 4 species names were not recognised:
#> 1. Bivalvia
#> 2. Gastropoda
#> 3. Nemertini
#> 4. Terebellida

# show AMBI results
df
#> # A tibble: 2 × 13
#>   station  AMBI AMBI_SD     H     S     fNA     N     I    II   III     IV
#>   <chr>   <dbl>   <dbl> <dbl> <int>   <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
#> 1 42      0.970   0.712  4.24    28 0          76 0.461 0.158 0.355 0.0132
#> 2 49      1.98    0.232  3.25    29 0.00337   297 0.115 0.470 0.389 0.0270
#> # ℹ 2 more variables: V <dbl>, Disturbance <chr>

# calculate DKI from AMBI results
df <- dplyr::mutate(df, DKI = DKI(AMBI, H, N, S))

dplyr::select(df, station, AMBI, H, N, S, DKI)
#> # A tibble: 2 × 6
#>   station  AMBI     H     N     S   DKI
#>   <chr>   <dbl> <dbl> <dbl> <int> <dbl>
#> 1 42      0.970  4.24    76    28 0.834
#> 2 49      1.98   3.25   297    29 0.671
```
