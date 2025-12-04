# Minimum AMBI as a linear function of salinity

Used by
[`DKI2()`](https://niva-denmark.github.io/ambiR/reference/DKI2.md),
adjusting the `AMBI` index to account for decreasing species diversity
with decreasing salinity.

## Usage

``` r
AMBI_sal(psal, intercept = 3.083, slope = -0.111)
```

## Arguments

- psal:

  numeric, salinity

- intercept:

  numeric, default 3.083

- slope:

  numeric, default -0.111

## Value

a numeric value AMBI_min

## Details

`AMBI_sal()` and
[`H_sal()`](https://niva-denmark.github.io/ambiR/reference/H_sal.md) are
named, respectively, *AMBI_min* and *H_max* in the DKI documentation
[(Carstensen et al., 2014)](https://dce2.au.dk/pub/SR93.pdf). They are
renamed in ambiR to reflect the fact that they are functions of salinity
and *not* minimum or maximum values from data being used.

## Examples

``` r
AMBI_sal(20.1)
#> [1] 0.8519
```
