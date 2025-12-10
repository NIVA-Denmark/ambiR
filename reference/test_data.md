# AMBI test dataset

Example data included with the AMBI tool from AZTI
(*example_BDheader.xls*).

## Usage

``` r
test_data
```

## Format

The test dataset `test_data` has 53 rows and 4 variables:

- station:

  3 sampling sites 1, 2, 3

- replicate:

  unique samples taken at each site, identified *a*, *b*, *c*

- species:

  Name of observed species/taxon

- count:

  Number of individuals

## Source

[AZTI](https://www.azti.es/en/ambi-international-reference-for-marine-environment-assessment/)

## Examples

``` r
head(test_data)
#> # A tibble: 6 × 4
#>   station replicate species             count
#>     <dbl> <chr>     <chr>               <dbl>
#> 1       1 a         Cumopsis fagei          2
#> 2       1 a         Diogenes pugilator      2
#> 3       1 a         Paradoneis armata       1
#> 4       1 b         Bathyporeia elegans     1
#> 5       1 b         Diogenes pugilator      5
#> 6       1 b         Dispio uncinata         1
```
