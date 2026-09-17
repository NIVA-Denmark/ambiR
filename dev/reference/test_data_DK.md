# Danish test dataset

Example data from Danish monitoring data. Used for testing DKI
calculations.

## Usage

``` r
test_data_DK
```

## Format

The test dataset `test_data_DK` has 112 rows and 4 variables:

- station:

  2 sampling sites "42", "49" *(ObservationsStedNavn)*

- sample:

  unique samples taken at each site, identified *1*, *2*, *3*, *4*, *5*
  *(Prøvetagningsnummer)*

- species:

  Name of observed species/taxon *(Artsnavn)*

- count:

  Number of individuals *(Antal)*

## Source

[Danish National Aquatic Monitoring and Assessment
Programme.](https://odaforalle.au.dk)

## Examples

``` r
head(test_data_DK)
#> # A tibble: 6 × 4
#>   station sample species                     count
#>   <chr>    <dbl> <chr>                       <dbl>
#> 1 42           3 Nephtys longosetosa             1
#> 2 42           3 Bathyporeia guilliamsoniana     2
#> 3 42           3 Gastrosaccus spinifer           1
#> 4 42           3 Parvicardium pinnulatum         1
#> 5 42           3 Gastropoda indet.               1
#> 6 42           3 Branchiostoma lanceolatum       1
```
