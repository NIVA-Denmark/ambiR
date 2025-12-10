# Returns species list for AMBI calculations

`AMBI_species()` returns a dataframe with list of species and AMBI
group. Called by the function
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md) and
then used to match species in observed data and find species groups.

*latest version 8th October 2024*

## Usage

``` r
AMBI_species(version = "")
```

## Arguments

- version:

  *string*, version of the species list to return. The default value is
  the empty string (`""`) which returns the latest version of the list
  *(8. October 2024)*. Currently, the only other valid value for
  `version` is `"2022"` *(31. May 2022)*.

## Value

A data frame with 11,952 rows\* and 3 columns:

- species:

  Species name or genus (spp.)

- group:

  Species group for AMBI index calculation: `1`, `2`, `3`, `4` or `5`. A
  value of `0` indicates that the species is not assigned to a species
  group.

- RA:

  reallocatable (`0` or `1`), a `1` indicates that a species could be
  re-assigned to a different species group.

## Details

The species groups, as described by [Borja et al. (2000)](#references):

- *Group I*  
  Species very sensitive to organic enrichment and present under
  unpolluted conditions (initial state). They include the specialist
  carnivores and some deposit-feeding *tubicolous polychaetes*.  

- *Group II*  
  Species indifferent to enrichment, always present in low densities
  with non-significant variations with time (from initial state, to
  slight unbalance). These include suspension feeders, less selective
  carnivores and scavengers.  

- *Group III*  
  Species tolerant to excess organic matter enrichment. These species
  may occur under normal conditions, but their populations are
  stimulated by organic enrichment (slight unbalance situations). They
  are surface deposit-feeding species, such as *tubicolous spionids*.  

- *Group IV*  
  Second-order opportunistic species (slight to pronounced unbalanced
  situations). Mainly small sized *polychaetes*: subsurface
  deposit-feeders, such as *cirratulids*.  

- *Group V*  
  First-order opportunistic species (pronounced unbalanced situations).
  These are deposit-feeders, which proliferate in reduced sediments.  

## References

Borja, Á., Franco, J., Pérez, V. (2000). “A Marine Biotic Index to
Establish the Ecological Quality of Soft-Bottom Benthos Within European
Estuarine and Coastal Environments.” *Marine Pollution Bulletin* 40
(12): 1100–1114.
[doi:10.1016/S0025-326X(00)00061-8](https://doi.org/10.1016/S0025-326X%2800%2900061-8)
.

## See also

[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md) which
uses the species list to calculate the AMBI index.

## Examples

``` r
AMBI_species() %>% head()
#>                         species group RA
#> 1             Aartsenia candida     1  0
#> 2           Abarenicola affinis     1  0
#> 3   Abarenicola affinis affinis     1  0
#> 4 Abarenicola affinis chilensis     3  0
#> 5        Abarenicola claparedei     1  0
#> 6         Abarenicola claparedi     1  0

AMBI_species() %>% tail()
#>                        species group RA
#> 11947               Zoantharia     1  0
#> 11948    Zoidbergus tenuimanus     3  0
#> 11949 Zoobotryon verticillatum     2  0
#> 11950   Zygochlamys patagonica     1  0
#> 11951   Zygonemertes virescens     2  0
#> 11952           Zygophylax sp.     2  0
```
