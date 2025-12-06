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

AZTI.ES

## Examples

``` r
summary(test_data)
#>     station       replicate           species              count       
#>  Min.   :1.000   Length:53          Length:53          Min.   : 1.000  
#>  1st Qu.:2.000   Class :character   Class :character   1st Qu.: 1.000  
#>  Median :2.000   Mode  :character   Mode  :character   Median : 1.000  
#>  Mean   :2.057                                         Mean   : 2.264  
#>  3rd Qu.:2.000                                         3rd Qu.: 2.000  
#>  Max.   :3.000                                         Max.   :11.000  
```
