
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ambiR <a href="https://niva-denmark.github.io/ambiR/"><img src="man/figures/logo.png" align="right" height="139" alt="ambiR website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/NIVA-Denmark/ambiR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/NIVA-Denmark/ambiR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This is an R package implementing **AZTI’s Marine Biotic Index**.

## Overview

The package allows the user to calculate both the *AMBI* index and the
multivariate *M-AMBI* from count or abundance data for benthic fauna
species.

In addition, this package includes functions to calculate different
versions of the *Danish Quality Index* (*DKI*) (in Danish: *Dansk
Kvalitetsindeks*), a derived benthic index based on AMBI.

- `AMBI()` - calculates the *AMBI* index.
- `MAMBI()` - calculates the multivariate *M-AMBI* index.
- `Hdash()` - calculates *H’*, the Shannon diversity index.
- `DKI2()` - calculates the salinity-normalised Danish quality index
  *DKI (v2)*.
- `DKI()` - calculates the Danish quality index *DKI*.

To get started, see `vignette("ambiR")`. For details about running in
interactive mode, see `vignette("interactive")`.

The AMBI index was developed by Ángel Borja and colleagues at AZTI. For
background and explanation of the method for calculation of the AMBI
index see `vignette("background")`. You can also find a link to download
the original AMBI software.

## Installation

You can install the development version of ambiR from
[GitHub](https://github.com/niva-denmark/ambiR/) with:

``` r
# install.packages("devtools")
devtools::install_github("NIVA-Denmark/ambiR")
```

## Examples

This is a basic example using a very small dataset, with 2 stations. In
each station there are 3 species counts. The data is organised in a
dataframe with 3 columns in a so-called “long” format. That is, each
count is recorded in a separate row.

By default, the `AMBI` function returns both the AMBI results *and* a
list of which AMBI groups species names in input data were assigned to.
Here, we also use the argument `format_pct` to show the estimated
fractions as percentages. See the function documentation for more
details: `AMBI()`.

``` r
library(ambiR)

df <- data.frame(station = c("1","1","1","2","2","2"),
                 species = c("Acidostoma neglectum",
                             "Acrocirrus validus",
                             "Capitella nonatoi",
                             "Acteocina bullata",
                             "Austrohelice crassa",
                             "Capitella nonatoi"),
                 count = c(8, 14, 23, 13, 17, 11))

AMBI(df, by = c("station"), format_pct=1)
#> $AMBI
#> # A tibble: 2 × 12
#>   station  AMBI     H     S fNA       N I     II    III   IV    V    
#>   <chr>   <dbl> <dbl> <int> <chr> <dbl> <chr> <chr> <chr> <chr> <chr>
#> 1 1        5.43  1.46     3 17.8%    45 0.0%  0.0%  0.0%  37.8% 62.2%
#> 2 2        4.10  1.56     3 0.0%     41 31.7% 0.0%  0.0%  0.0%  68.3%
#> # ℹ 1 more variable: Disturbance <chr>
#> 
#> $matched
#>   station              species      species_matched count group RA
#> 1       1 Acidostoma neglectum Acidostoma neglectum     8     0  0
#> 2       1   Acrocirrus validus   Acrocirrus validus    14     4  0
#> 3       1    Capitella nonatoi    Capitella nonatoi    23     5  0
#> 4       2    Acteocina bullata    Acteocina bullata    13     1  0
#> 5       2  Austrohelice crassa  Austrohelice crassa    17     5  0
#> 6       2    Capitella nonatoi    Capitella nonatoi    11     5  0
```

Another example using the supplied `test_data`.

``` r
library(ambiR)

## calling AMBI using the test data set
AMBI(test_data, by=c("station"), var_rep = "replicate", format_pct=1)
#> $AMBI
#> # A tibble: 3 × 13
#>   station  AMBI AMBI_SD     H     S fNA       N I     II    III   IV    V    
#>     <dbl> <dbl>   <dbl> <dbl> <int> <chr> <dbl> <chr> <chr> <chr> <chr> <chr>
#> 1       1  1.48   0.338  1.80     6 0.0%     16 12.5% 75.0% 12.5% 0.0%  0.0% 
#> 2       2  1.89   0.238  3.54    22 0.0%     80 40.0% 13.8% 30.0% 15.0% 1.2% 
#> 3       3  4.12   0.884  2.50     9 0.0%     24 0.0%  12.5% 29.2% 8.3%  50.0%
#> # ℹ 1 more variable: Disturbance <chr>
#> 
#> $AMBI_rep
#> # A tibble: 8 × 11
#>   station replicate  AMBI     S fNA       N I     II    III   IV    V    
#>     <dbl> <chr>     <dbl> <dbl> <chr> <dbl> <chr> <chr> <chr> <chr> <chr>
#> 1       1 a          1.8      3 0.0%      5 0.0%  80.0% 20.0% 0.0%  0.0% 
#> 2       1 b          1.5      3 0.0%      7 14.3% 71.4% 14.3% 0.0%  0.0% 
#> 3       1 c          1.12     2 0.0%      4 25.0% 75.0% 0.0%  0.0%  0.0% 
#> 4       2 a          1.88    12 0.0%     32 40.6% 15.6% 21.9% 21.9% 0.0% 
#> 5       2 b          2.13    12 0.0%     19 31.6% 15.8% 36.8% 10.5% 5.3% 
#> 6       2 c          1.66    10 0.0%     29 44.8% 10.3% 34.5% 10.3% 0.0% 
#> 7       3 a          3.5      5 0.0%      6 0.0%  33.3% 16.7% 33.3% 16.7%
#> 8       3 b          4.75     6 0.0%     18 0.0%  5.6%  33.3% 0.0%  61.1%
#> 
#> $matched
#> # A tibble: 53 × 7
#>    station replicate species             species_matched     count group    RA
#>      <dbl> <chr>     <chr>               <chr>               <dbl> <dbl> <dbl>
#>  1       1 a         Cumopsis fagei      Cumopsis fagei          2     2     0
#>  2       1 a         Diogenes pugilator  Diogenes pugilator      2     2     0
#>  3       1 a         Paradoneis armata   Paradoneis armata       1     3     0
#>  4       1 b         Bathyporeia elegans Bathyporeia elegans     1     1     0
#>  5       1 b         Diogenes pugilator  Diogenes pugilator      5     2     0
#>  6       1 b         Dispio uncinata     Dispio uncinata         1     3     0
#>  7       1 c         Astarte sp.         Astarte sp.             1     1     0
#>  8       1 c         Diogenes pugilator  Diogenes pugilator      3     2     0
#>  9       2 a         Cumopsis fagei      Cumopsis fagei          1     2     0
#> 10       2 a         Glycera tridactyla  Glycera tridactyla      2     2     0
#> # ℹ 43 more rows
```
