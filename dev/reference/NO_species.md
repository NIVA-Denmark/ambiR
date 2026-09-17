# Returns species list used by Norwegian index calculations

`NO_species()` returns a dataframe with list of species and
sensitivities for use in functions calculating Norwegian indices
[`ISI()`](https://niva-denmark.github.io/ambiR/dev/reference/ISI.md) and
[`NSI()`](https://niva-denmark.github.io/ambiR/dev/reference/NSI.md).

*latest version 13th November 2024*

## Usage

``` r
NO_species()
```

## Value

A data frame with 760 rows\* and 10 columns:

- species:

  Species name or genus (spp.)

- ES100avg_2018:

  Species sensitivity value for ES100 used to calculate
  [`NSI()`](https://niva-denmark.github.io/ambiR/dev/reference/NSI.md)
  version 2018

- ES100min5_2018:

  Species sensitivity value used to calculate
  [`ISI()`](https://niva-denmark.github.io/ambiR/dev/reference/ISI.md)
  version 2018

- ES100avg_2012:

  Species sensitivity value for ES100 used to calculate
  [`NSI()`](https://niva-denmark.github.io/ambiR/dev/reference/NSI.md)
  version 2012

- ES100min5_2012:

  Species sensitivity value used to calculate
  [`ISI()`](https://niva-denmark.github.io/ambiR/dev/reference/ISI.md)
  version 2012

- group_AMBI:

  AMBI species group. This information is included by [Borgersen et al.
  (2019)](#references). For the authoritative list see
  [`AMBI_species()`](https://niva-denmark.github.io/ambiR/dev/reference/AMBI_species.md)

- group_NSI:

  NSI species group. See [Borgersen et al. (2019)](#references)

- group_ISI:

  ISI species group

- Revidert:

  Indicates that information has been revised.

- Kommentar:

  Comment in Norwegian describing revision.

## Details

This table contains the species-specific sensitivities used to calculate
the Norwegian indices
[`ISI()`](https://niva-denmark.github.io/ambiR/dev/reference/ISI.md) and
[`NSI()`](https://niva-denmark.github.io/ambiR/dev/reference/NSI.md).

Similarly to the `AMBI` index, the principle of the Norwegian quality
indices is that high species diversity indicates good environmental
status and species primarily found at sites with high diversity and
considered sensitive, while sites with low species diversity are
considered as stressed environments and species more frequently found at
such sites are considered more tolerant. Species diversity thus serves
as a proxy for the degree of disturbance at a site.

The calculation of species sensitivity values for ISI and NSI is based
on analysis of `ES100` values calculated for a large number of grab
samples from the Norwegian monitoring data. The sensitivity values for a
species are the weighted averages of `ES100` values across samples where
the species was present.

- *ES100avg_2018*  
  The weighted average of `ES100` values across samples where the
  species was present. Theses are the updated 2018 values.  

- *ES100min5_2018*  
  The weighted average of `ES100` values across samples where the
  species was present but based on the 5 samples having the lowest
  `ES100` value. This value was determined only for species found in at
  least six samples. Theses are the updated 2018 values.  

- *ES100avg_2012*  
  The weighted average of `ES100` values across samples where the
  species was present. These are the values determined by [Rygg &
  Norling (2013)](#references)  

- *ES100min5_2012*  
  The weighted average of `ES100` values across samples where the
  species was present but based on the 5 samples having the lowest
  `ES100` value. This value was determined only for species found in at
  least six samples. These are the values determined by [Rygg & Norling
  (2013)](#references)  

, For more details, please see [Borgersen et al. (2019)](#references):

## References

"Sensitivitetsverdier for NSI2018 og ISI 2018_13.11.2024.xlsx" retrieved
01-09-2026
https://www.vannportalen.no/sharepoint/downloaditem?id=01FM3LD2WM4F42XCAEDNBZLJRZMUOM66OP
Borgersen, G., Trannum, H.C., Gundersen, H., Vedal, J. (2019).
Oppdatering av bløtbunnsartenes sensitivitetsverdier (Report No. 7366).
Norsk institutt for vannforskning (NIVA).
<https://hdl.handle.net/11250/2600903> Rygg, B., Norling, K. (2013).
Norwegian Sensitivity Index (NSI) for marine macroinvertebrates, and an
update of Indicator Species Index (ISI). (Report No. 6475). Norsk
institutt for vannforskning (NIVA). 46 pp.

## See also

[`NSI()`](https://niva-denmark.github.io/ambiR/dev/reference/NSI.md) and
[`ISI()`](https://niva-denmark.github.io/ambiR/dev/reference/ISI.md) use
this species list to calculate these indices.

## Examples

``` r

NO_species() %>% head()
#> # A tibble: 6 × 10
#>   species   ES100avg_2018 ES100min5_2018 ES100avg_2012 ES100min5_2012 group_AMBI
#>   <chr>             <dbl>          <dbl>         <dbl>          <dbl>      <dbl>
#> 1 Abra alba          21.7           3.71          19.5           3.82          3
#> 2 Abra lon…          26.2           8.28          23.0           9.40          3
#> 3 Abra nit…          23.1           4.27          22.0           5.84          3
#> 4 Abra pri…          31.0          14.4           32.1          25.7           1
#> 5 Abyssoni…          29.0           9.14          31.7          12.6           1
#> 6 Abyssoni…          29.1          10.4           29.1          10.9           1
#> # ℹ 4 more variables: group_NSI <dbl>, group_ISI <dbl>, Revidert <chr>,
#> #   Kommentar <chr>

NO_species() %>% tail()
#> # A tibble: 6 × 10
#>   species   ES100avg_2018 ES100min5_2018 ES100avg_2012 ES100min5_2012 group_AMBI
#>   <chr>             <dbl>          <dbl>         <dbl>          <dbl>      <dbl>
#> 1 Yoldiell…          25.5           9.57          22.2          11.3           1
#> 2 Yoldiell…          31.7           9.14          30.7          12.4           1
#> 3 Yoldiell…          25.3          14.9           NA            NA            NA
#> 4 Yoldiell…          25.8          10.5           NA            NA             1
#> 5 Zeppelin…          NA            NA             14.6           9.82          4
#> 6 Zoealarve          NA            NA             24.9           8.90         NA
#> # ℹ 4 more variables: group_NSI <dbl>, group_ISI <dbl>, Revidert <chr>,
#> #   Kommentar <chr>
```
