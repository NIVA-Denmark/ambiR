# Norwegian test dataset

Example data from Norwegian monitoring data. Used for testing Norwegian
index calculations.

## Usage

``` r
test_data_NO
```

## Format

The test dataset `test_data_NO` has 396 rows and 4 variables:

- station:

  2 sampling sites "Ærøy (U10)", "Ærøydypet (U12)"
  *(Vannlokalitetsnavn)*

- sample:

  unique samples taken at each site, identified *G1*, *G2* *(Provenr)*

- species:

  Name of observed species/taxon *(VitenskapligNavn)*

- count:

  Number of individuals *(Verdi)*

## Source

[Vann-Nett](https://vann-nett.no/)

## Examples

``` r
head(test_data_NO)
#> # A tibble: 6 × 4
#>   station         sample species             count
#>   <chr>           <chr>  <chr>               <dbl>
#> 1 Ærøy (U10)      G1     Dipolydora flava        1
#> 2 Ærøy (U10)      G2     Zoealarve (Stadium)     1
#> 3 Ærøydypet (U12) G1     Zoealarve (Stadium)     2
#> 4 Ærøydypet (U12) G2     Zoealarve (Stadium)     2
#> 5 Ærøy (U10)      G1     Zoealarve (Stadium)     5
#> 6 Ærøy (U10)      G2     Animalia                1
```
