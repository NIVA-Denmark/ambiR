# Maximum H' as a linear function of salinity

Used by
[`DKI2()`](https://niva-denmark.github.io/ambiR/reference/DKI2.md),
adjusting the Shannon diversity index `H'` to account for decreasing
species diversity with decreasing salinity.

## Usage

``` r
H_sal(psal, intercept = 2.117, slope = 0.086)
```

## Arguments

- psal:

  numeric salinity

- intercept:

  numeric, default 2.117

- slope:

  numeric default 0.086

## Value

a numeric value H_max

## Details

[`AMBI_sal()`](https://niva-denmark.github.io/ambiR/reference/AMBI_sal.md)
and `H_sal()` are named, respectively, *AMBI_min* and *H_max* in the DKI
documentation [(Carstensen et al.,
2014)](https://dce2.au.dk/pub/SR93.pdf). They are renamed in ambiR to
reflect the fact that they are functions of salinity and *not* minimum
or maximum values from data being used.

## Examples

``` r
H_sal(20.1)
#> [1] 3.8456
```
