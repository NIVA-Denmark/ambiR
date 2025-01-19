
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ambiR

<!-- badges: start -->

[![R-CMD-check](https://github.com/NIVA-Denmark/ambiR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/NIVA-Denmark/ambiR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This is an R package implementing **AZTI’s Marine Biotic Index**.

## Overview

The package allows the user to calculate both the *AMBI* index and the
multivariate *M-AMBI* from count data for benthic species.

The original software from AZTI can be downloaded from
<https://ambi.azti.es/>.

In addition, this package includes functions to calculate different
versions of the *Danish Quality Index* (*DKI*) (in Danish: *Dansk
Kvalitetsindeks*), a derived benthic index based on AMBI.

- `AMBI()` - calculates the *AMBI* index.
- `MAMBI()` - calculates the multivariate *M-AMBI* index.
- `Hdash()` - calculates *H’*, the Shannon diversity index.
- `DKI2()` - calculates the salinity-normalised Danish quality index
  *DKI (v2)*.
- `DKI()` - calculates the Danish quality index *DKI*.

## Species Groups

Input to the `AMBI()` function is a dataframe of species counts with
optional grouping variables, e.g. station or replicate IDs. The function
matches species names in the input data with names in the AMBI species
list, in order to categorise the observed species according to the AMBI
method. The tool then calculates the *AMBI* index resulting from the
distribution of individuals between the groups.

The AMBI species list gives the groups (I, II, III, IV, V) in which each
species is classified, as described by Borja et al (2000):

- *Group I*  
  Species very sensitive to organic enrichment and present under
  unpolluted conditions (initial state). They include the specialist
  carnivores and some deposit- feeding *tubicolous polychaetes*.
- *Group II*  
  Species indifferent to enrichment, always present in low densities
  with non-significant variations with time (from initial state, to
  slight unbalance). These include suspension feeders, less selective
  carnivores and scavengers.
- *Group III*  
  Species tolerant to excess organic matter enrichment. These species
  may occur under normal conditions, but their populations are
  stimulated by organic richment (slight unbalance situations). They are
  surface deposit-feeding species, as *tubicolous spionids*.
- *Group IV*  
  Second-order opportunistic species (slight to pronounced unbalanced
  situations). Mainly small sized *polychaetes*: subsurface
  deposit-feeders, such as *cirratulids*.
- *Group V*  
  First-order opportunistic species (pronounced unbalanced situations).
  These are deposit- feeders, which proliferate in reduced sediments.

The list of species and their groups has been updated several times by
the authors of the AMBI software. The version of the list used here is
from 8th October 2024.

## Installation

You can install the development version of ambiR from
[GitHub](https://github.com/niva-denmark/ambiR/) with:

``` r
# install.packages("pak")
pak::pak("niva-denmark/ambiR")
```

## Examples

This is a basic example using a small dataset.

``` r
library(ambiR)

df <- data.frame(station = c("1","1","2","2","2"),
species = c("Acidostoma neglectum",
             "Acrocirrus validus",
             "Acteocina bullata",
             "Austrohelice crassa",
             "Capitella nonatoi"),
             count = c(2, 4, 5, 3, 7))

AMBI(df, by = c("station"))
#> $AMBI
#> # A tibble: 2 × 11
#>   station  AMBI     H     S   fNA     N     I    II   III    IV     V
#>   <chr>   <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 1         4.5 0.918     2 0.333     6 0         0     0     1 0    
#> 2 2         4   1.51      3 0        15 0.333     0     0     0 0.667
#> 
#> $matched
#>   station              species count group RA
#> 1       1 Acidostoma neglectum     2     0  0
#> 2       1   Acrocirrus validus     4     4  0
#> 3       2    Acteocina bullata     5     1  0
#> 4       2  Austrohelice crassa     3     5  0
#> 5       2    Capitella nonatoi     7     5  0
#> 
#> $warnings
#> # A tibble: 3 × 2
#>   station warning                                                               
#>   <chr>   <chr>                                                                 
#> 1 1       The percentage of individuals not assigned to a group is higher than …
#> 2 1       The (not null) number of species is less than 3 [2].                  
#> 3 1       The (not null) number of individuals is less than 6 [4].
```

Another example using the supplied `test_data`.

``` r
library(ambiR)

## calling AMBI using the test data set
AMBI(test_data, by=c("station"), var_rep = "replicate")
#> $AMBI
#> # A tibble: 3 × 11
#>   station  AMBI     H     S   fNA     N     I    II   III     IV      V
#>     <dbl> <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1       1  1.48  1.80     6     0    16 0.125 0.75  0.125 0      0     
#> 2       2  1.89  3.54    22     0    80 0.4   0.138 0.3   0.15   0.0125
#> 3       3  4.12  2.50     9     0    24 0     0.125 0.292 0.0833 0.5   
#> 
#> $matched
#> # A tibble: 53 × 6
#>    station replicate species             count group    RA
#>      <dbl> <chr>     <chr>               <dbl> <dbl> <dbl>
#>  1       1 a         Cumopsis fagei          2     2     0
#>  2       1 a         Diogenes pugilator      2     2     0
#>  3       1 a         Paradoneis armata       1     3     0
#>  4       1 b         Bathyporeia elegans     1     1     0
#>  5       1 b         Diogenes pugilator      5     2     0
#>  6       1 b         Dispio uncinata         1     3     0
#>  7       1 c         Astarte sp.             1     1     0
#>  8       1 c         Diogenes pugilator      3     2     0
#>  9       2 a         Cumopsis fagei          1     2     0
#> 10       2 a         Glycera tridactyla      2     2     0
#> # ℹ 43 more rows
#> 
#> $warnings
#> NULL
```
