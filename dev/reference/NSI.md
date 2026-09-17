# Calculates NSI, the Norwegian Sensitivity Index

`NSI()` matches a list of species counts with the Norwegian species list
and calculates *NSI* the Norwegian Sensitivity Index. [(Borgersen et al,
2019)](#references)

## Usage

``` r
NSI(
  df,
  by = NULL,
  var_species = "species",
  var_count = "count",
  df_species = NULL,
  version = "2018"
)
```

## Arguments

- df:

  a dataframe of species observations

- by:

  a vector of column names found in `df` by which calculations should be
  grouped *e.g. c("station","date")*

- var_species:

  name of the column in `df` containing species names

- var_count:

  name of the column in `df` containing count/density/abundance

- df_species:

  *optional* dataframe with user-specified species list.

- version:

  *string*, version of the index to be calculated. The default value is
  `"2018"`. The the only other valid value for `version` is `"2012"`.

## Value

a list of two dataframes:

- `NSI` : results of the NSI index calculations. For each unique
  combination of `by`variables the following values are calculated:

  - `NSI<version>` : the sensitivity index `NSI2018` or `NSI2012`

  - `S` : the number of species

  - `N` : the number of individuals

- `match` : the original dataframe with columns added from the species
  list. For a user-specified list provided `df_species`, all columns
  will be included. If the user-specified species list contains only a
  single column with species names, then a new column `match` will be
  created, with a value of `1` indicating a match and an `NA` value
  where no match was found. One of the following columns will be
  included, depending on the NSI version:

  - `ES100avg_2018` : species sensitivity values used to calculate
    `NSI2018`

  - `ES100avg_2012` : species sensitivity values used to calculate
    `NSI2012`

## Details

If the function is called with the argument `check_species = TRUE` then
only species which are successfully matched with the specified species
list are included in the calculations. This is the default. If the
function is called with `check_species = FALSE`then all rows are
counted.

## References

Borgersen, G., Trannum, H.C., Gundersen, H., Vedal, J. (2019).
Oppdatering av bløtbunnsartenes sensitivitetsverdier (Report No. 7366).
Norsk institutt for vannforskning (NIVA).
<https://hdl.handle.net/11250/2600903>

Rygg, B., Norling, K. (2013). Norwegian Sensitivity Index (NSI) for
marine macroinvertebrates, and an update of Indicator Species Index
(ISI). (Report No. 6475). Norsk institutt for vannforskning (NIVA). 46
pp.

## See also

[`ISI()`](https://niva-denmark.github.io/ambiR/dev/reference/ISI.md)
which calculates the Indicator Species Index, another Norwegian benthic
diversity index. For more details, see\`vignette("other-indices").

## Examples

``` r

NSI(test_data_NO, by="station", var_species ="species", var_count="count")
#> $NSI
#> # A tibble: 2 × 4
#>   station         NSI2018     N     S
#>   <chr>             <dbl> <dbl> <int>
#> 1 Ærøy (U10)         29.1   526    63
#> 2 Ærøydypet (U12)    24.5   188    40
#> 
#> $matched
#> # A tibble: 206 × 13
#>    station       sample species count ES100avg_2018 ES100min5_2018 ES100avg_2012
#>    <chr>         <chr>  <chr>   <dbl>         <dbl>          <dbl>         <dbl>
#>  1 Ærøy (U10)    G1     Dipoly…     1            NA             NA          NA  
#>  2 Ærøy (U10)    G2     Zoeala…     1            NA             NA          NA  
#>  3 Ærøydypet (U… G1     Zoeala…     2            NA             NA          NA  
#>  4 Ærøydypet (U… G2     Zoeala…     2            NA             NA          NA  
#>  5 Ærøy (U10)    G1     Zoeala…     5            NA             NA          NA  
#>  6 Ærøy (U10)    G2     Animal…     1            NA             NA          NA  
#>  7 Ærøy (U10)    G1     Tanaid…    13            NA             NA          28.6
#>  8 Ærøy (U10)    G2     Tanaid…     1            NA             NA          28.6
#>  9 Ærøydypet (U… G2     Ophiur…     1            NA             NA          27.8
#> 10 Ærøy (U10)    G1     Bivalv…     1            NA             NA          28.4
#> # ℹ 196 more rows
#> # ℹ 6 more variables: ES100min5_2012 <dbl>, group_AMBI <dbl>, group_NSI <dbl>,
#> #   group_ISI <dbl>, Revidert <chr>, Kommentar <chr>
#> 
```
