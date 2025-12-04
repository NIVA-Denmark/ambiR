# Calculates H' the Shannon diversity index

`Hdash()` matches a list of species counts with the AMBI species list
and calculates *H'* the Shannon diversity index [Shannon,
1948](https://niva-denmark.github.io/ambiR/reference/%5Cdoi%7B10.1002/j.1538-7305.1948.tb01338.x%7D)

## Usage

``` r
Hdash(
  df,
  by = NULL,
  var_species = "species",
  var_count = "count",
  check_species = TRUE,
  df_species = NULL
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

- check_species:

  boolean, default = TRUE. If TRUE, then only species found in the
  species list are included in *H'* index. By default, the AZTI species
  list is used.

- df_species:

  *optional* dataframe with user-specified species list.

## Value

a list of two dataframes:

- `H` : results of the AMBI index calculations. For each unique
  combination of `by`variables the following values are calculated:

  - `H` : the Shannon-Wiener Diversity Index, *H'*

  - `S` : the number of species

  - `N` : the number of individuals

- `match` : the original dataframe with columns added from the species
  list. For a user-specified list provided `df_species`, all columns
  will be included. If the user-specified species list contains only a
  single column with species names, then a new column `match` will be
  created, with a value of `1` indicating a match and an `NA` value
  where no match was found.

For the default AZTI species list the following additional columns will
be included:

- `group` : showing the AMBI species group

- `RA` : indicating that the species is *reallocatable* according to the
  AZTI list. That is, it could be re-assigned to a different species
  group.

## Details

If the function is called with the argument `check_species = TRUE` then
only species which are successfully matched with the specified species
list are included in the calculations. This is the default. If the
function is called with `check_species = FALSE`then all rows are
counted.

## Examples

``` r
Hdash(test_data, by=c("station"))
#> $H
#> # A tibble: 3 × 4
#>   station     H     N     S
#>     <dbl> <dbl> <dbl> <int>
#> 1       1  1.80    16     6
#> 2       2  3.54    80    22
#> 3       3  2.50    24     9
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
```
