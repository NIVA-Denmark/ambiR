# Calculates AMBI, the AZTI Marine Biotic Index

`AMBI()` matches a list of species counts with the AMBI species list and
calculates the AMBI index.

## Usage

``` r
AMBI(
  df,
  by = NULL,
  var_rep = NA_character_,
  var_species = "species",
  var_count = "count",
  df_species = NULL,
  var_group_AMBI = "group",
  groups_strict = TRUE,
  quiet = FALSE,
  interactive = FALSE,
  format_pct = NA,
  show_class = TRUE,
  exact_species_match = FALSE
)
```

## Arguments

- df:

  a dataframe of species observations

- by:

  a vector of column names found in `df` by which calculations should be
  grouped *e.g. c("station","date")*

- var_rep:

  *optional* column name in `df` which contains the name of the column
  identifying replicates. If replicates are used, the AMBI index will be
  calculated for each replicate before an average is calculated for each
  combination of `by` variables. If the Shannon diversity index `H` is
  calculated this will be done for species counts collected within `by`
  groups without any consideration of replicates.

- var_species:

  name of the column in `df` containing species names

- var_count:

  name of the column in `df` containing count/density/abundance

- df_species:

  *optional* dataframe of user-specified species groups. By default, the
  function matches species in `df` with the official species list from
  AZTI. If a dataframe with a user-defined list of species is provided,
  then a search for species groups will also be made in this list. *see
  [Details](#species-matching-and-interactive-mode)*.

- var_group_AMBI:

  *optional* name of the column in `df_species` containing the groups
  for the AMBI index calculations. These should be specified as integer
  values from 1 to 7. Any other values will be ignored. If `df_species`
  is not specified then `var_group_AMBI` will be ignored.

- groups_strict:

  By default, any user-assigned species group which conflicts with an
  AZTI group assignment will be ignored and the original group remains
  unchanged. If the argument `groups_strict = FALSE` is used then
  user-assigned groups will always override AMBI groups in case of
  conflict. *DO NOT use this option unless you are sure you know what
  you are doing! It could invalidate your results.*

- quiet:

  warnings about low numbers of species and/or individuals are contained
  in the `warnings` dataframe. By default (`quiet = FALSE`) these
  warnings are also shown in the console. If the function is called with
  the parameter `quiet = TRUE` then warnings will not be displayed in
  the console.

- interactive:

  (default `FALSE`) if a species name in the input data is not found in
  the AZTI species list, then this will be seen in the output dataframe
  `matched`. If *interactive* mode is selected, the user will be given
  the opportunity to assign *manually* a species group (*I, II, III, IV,
  V*) or to mark the species as *not assigned* to a species group (see
  details).

- format_pct:

  (*optional*) By default, frequency results including the fraction of
  total numbers within each species group are expressed as real numbers
  . If this is argument is given a positive integer value (e.g.
  `format_pct = 2`) then the fractions are expressed as percentages with
  the number of digits shown after the decimal point equal to the number
  specified. *NOTE* by formatting as percentages, values are converted
  to text and may lose precision.

- show_class:

  (default `TRUE`). If `TRUE` then the `AMBI` results will include a
  column showing the AMBI disturbance classification *Undisturbed*,
  *Slightly disturbed*, *Moderately disturbed*, or *Heavily disturbed*.

- exact_species_match:

  by default, a family name without *sp.* will be matched with a family
  name on the AMBI (or user-specified) species list which includes
  *sp.*. If the option `exact_species_match = TRUE` is used, species
  names will be matched only with identical names.

## Value

a list of dataframes:

- `AMBI` : results of the AMBI index calculations. For each unique
  combination of `by` variables, the following values are calculated:

  - `AMBI` : the AMBI index value

  - `AMBI_SD` : sample standard deviation of AMBI *included only when
    replicates are used* has specified `var_rep`.

  - `N` : number of individuals

  - `S` : number of species

  - `H` : Shannon diversity index *H'*

  - `fNA` : fraction of individuals *not assigned*, that is, matched to
    a species in the AZTI species with *Group 0*. Note that this is
    different from the number of rows where no match was found. These
    are excluded from the totals.

- `AMBI_rep` : results of the AMBI index calculations *per replicate*.
  This dataframe is present only if the observation data includes
  replicates and the user has specified `var_rep`. Similar to the main
  `AMBI` result but does not include results for `H` (Shannon diversity
  index) or for `AMBI_SD` (sample standard deviation of AMBI) which are
  not estimated at replicate level.

- `matched` : the original dataframe with columns added from the species
  list. Contains the following columns:

  - `group` : showing the species group. Any species/taxa in `df` which
    were not matched will have an `NA` value in this column.

  - `RA` : indicating that the species is *reallocatable* according to
    the AZTI list. That is, it could be re-assigned to a different
    species group.

  - `source` : this column is included only if a user-specified list was
    provided `df_species`, or if species groups were assigned
    interactively. An `'I'` in this column indicates that the group was
    assigned interactively. A
    `'U'`\_`shows that the group information came from a user-provided species list. An`NA\`
    value indicates that no interactive or user-provided changes were
    applied.

- `warnings` : a dataframe showing warnings for any combination of `by`
  variables a warning where

  - The percentage of individuals not assigned to a group is higher than
    20%

  - The (not null) number of species is less than 3

  - The (not null) number of individuals is less than 6

## Details

The theory behind the AMBI index calculations and details of the method,
as developed by [Borja et al.
(2000)](https://niva-denmark.github.io/ambiR/reference/%5Cdoi%7B10.1016/S0025-326X(00)00061-8%7D)

### AMBI method

Species can be matched to one of five groups, the distribution of
individuals between the groups reflecting different levels of stress on
the ecosystem.

- *Group I*. Species very sensitive to organic enrichment and present
  under unpolluted conditions (initial state). They include the
  specialist carnivores and some deposit- feeding *tubicolous
  polychaetes*.

- *Group II*. Species indifferent to enrichment, always present in low
  densities with non-significant variations with time (from initial
  state, to slight unbalance). These include suspension feeders, less
  selective carnivores and scavengers.

- *Group III*. Species tolerant to excess organic matter enrichment.
  These species may occur under normal conditions, but their populations
  are stimulated by organic enrichment (slight unbalance situations).
  They are surface deposit-feeding species, as *tubicolous spionids*.

- *Group IV*. Second-order opportunistic species (slight to pronounced
  unbalanced situations). Mainly small sized *polychaetes*: subsurface
  deposit-feeders, such as *cirratulids*.

- *Group V*. First-order opportunistic species (pronounced unbalanced
  situations). These are deposit- feeders, which proliferate in reduced
  sediments.

The distribution of these ecological groups, according to their
sensitivity to pollution stress, provides a BI with eight levels, from 0
to 7

*Biotic Coefficient = (0.0 \* GI + l.5 \* GII + 3.0 \* GIII + 4.5 \*
GIV + 6.0 \* GV)*

where:

*Gn := fraction of individuals in Group n \[I, II, III, IV, V\]*

Under certain circumstances, the AMBI index should not be used:

- The percentage of individuals not assigned to a group is higher than
  20%

- The (not null) number of species is less than 3

- The (not null) number of individuals is less than 6

In these cases the function will still perform the calculations but will
also return a warning.(see below)

### Results

The output of the function consists of a list of at least three
dataframes:

- `AMBI` containing the calculated `AMBI` index, as well as other
  information.

- (`AMBI_rep`) generated only if replicates are used, showing the `AMBI`
  index for each replicate

- `matched` showing the species matches used

- `warnings` containing any warnings generated regarding numbers of of
  species or numbers of individuals

### Species matching and *interactive* mode

The function will check for a species list supplied in the function call
using the argument `df_species`, if this is specified. The function will
also search for names in the AMBI standard list. After this, if no match
is found in either, then the species will be recorded with a an
`NA`value for species group and will be ignored in calculations.

By calling the function once and then checking the output from this
first function call, the user can identify species names which were not
matched. Then, if necessary, they can provide or update a dataframe with
a list of user-defined species group assignments, before running the
function a second time.

#### Conflicts

If there is a conflict between a user-provided group assignment for a
species and the group specified in the AMBI species group information,
only one of them will be selected. The outcome depends on a number of
things:

- some species in the AMBI list are considered *reallocatable* (RA) -
  that is, there can be disagreement about which species group they
  should belong to. For these species, any user-specified groups will
  replace the default group.

- if a species is not *reallocatable*, then any user-specified groups
  will *by default* be ignored. However, if the function is called with
  the argument `groups_strict = FALSE` then the user-specified groups
  will override AMBI species groups.

Any conflicts and their outcomes will be recorded in the `matched`
output.

#### *interactive* mode

If the function is called in
[interactive](https://niva-denmark.github.io/ambiR/reference/articles/interactive.md)
mode, by using the argument `interactive = TRUE` then the user has an
opportunity to *manually* assign species groups (*I, II, III, IV, V*)
for any species names which were not identified. The user does this by
typing `1`, `2`, `3`, `4` or `5` and pressing *Enter*. Alternatively,
the user can type `0` to mark the species as recognized but not assigned
to a group. By typing *Enter* without any number the species will be
recorded as unidentified (`NA`). This is the same result which would
have been returned when calling the function in non-interactive mode.
There are two other options: typing `s` will display a list of 10
species names which occur close to the unrecognized name when names are
sorted in alphabetical order. Entering `s` a second time will display
the next 10 names, and so on. Finally, entering `x` will abort the
interactive species assignment process. Any species groups assigned
manually at this point will be discarded and the calculations will
process as in the non-interactive mode.

Any user-provided group information will be recorded in the `matched`
results.

## See also

[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)
which calculates *M-AMBI* the multivariate AMBI index using results of
`AMBI()`.

## Examples

``` r
# example (1) - using test data included with package

AMBI(test_data, by=c("station"), var_rep="replicate")
#> $AMBI
#> # A tibble: 3 × 13
#>   station  AMBI AMBI_SD     H     S   fNA     N     I    II   III     IV      V
#>     <dbl> <dbl>   <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1       1  1.48   0.338  1.80     6     0    16 0.125 0.75  0.125 0      0     
#> 2       2  1.89   0.238  3.54    22     0    80 0.4   0.138 0.3   0.15   0.0125
#> 3       3  4.12   0.884  2.50     9     0    24 0     0.125 0.292 0.0833 0.5   
#> # ℹ 1 more variable: Disturbance <chr>
#> 
#> $AMBI_rep
#> # A tibble: 8 × 11
#>   station replicate  AMBI     S   fNA     N     I     II   III    IV      V
#>     <dbl> <chr>     <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>  <dbl>
#> 1       1 a          1.8      3     0     5 0     0.8    0.2   0     0     
#> 2       1 b          1.5      3     0     7 0.143 0.714  0.143 0     0     
#> 3       1 c          1.12     2     0     4 0.25  0.75   0     0     0     
#> 4       2 a          1.88    12     0    32 0.406 0.156  0.219 0.219 0     
#> 5       2 b          2.13    12     0    19 0.316 0.158  0.368 0.105 0.0526
#> 6       2 c          1.66    10     0    29 0.448 0.103  0.345 0.103 0     
#> 7       3 a          3.5      5     0     6 0     0.333  0.167 0.333 0.167 
#> 8       3 b          4.75     6     0    18 0     0.0556 0.333 0     0.611 
#> 
#> $matched
#> # A tibble: 53 × 7
#>    station replicate species             species_matched     count group    RA
#>      <dbl> <chr>     <chr>               <chr>               <dbl> <dbl> <dbl>
#>  1       1 a         Cumopsis fagei      Cumopsis fagei          2     2     0
#>  2       1 a         Diogenes pugilator  Diogenes pugilator      2     2     0
#>  3       1 a         Paradoneis armata   Paradoneis armata       1     3     0
#>  4       1 b         Bathyporeia elegans Bathyporeia elegans     1     1     0
#>  5       1 b         Diogenes pugilator  Diogenes pugilator      5     2     0
#>  6       1 b         Dispio uncinata     Dispio uncinata         1     3     0
#>  7       1 c         Astarte sp.         Astarte sp.             1     1     0
#>  8       1 c         Diogenes pugilator  Diogenes pugilator      3     2     0
#>  9       2 a         Cumopsis fagei      Cumopsis fagei          1     2     0
#> 10       2 a         Glycera tridactyla  Glycera tridactyla      2     2     0
#> # ℹ 43 more rows
#> 


# example (2)

df <- data.frame(station = c("1","1","2","2","2"),
species = c("Acidostoma neglectum",
            "Acrocirrus validus",
            "Acteocina bullata",
            "Austrohelice crassa",
            "Capitella nonatoi"),
            count = c(2, 4, 5, 3, 7))

 AMBI(df, by = c("station"))
#> Warning: station 1: The percentage of individuals not assigned to a group is higher than
#> 20% [33.3%].
#> Warning: station 1: The (not null) number of species is less than 3 [2].
#> Warning: station 1: The (not null) number of individuals is less than 6 [4].
#> $AMBI
#> # A tibble: 2 × 12
#>   station  AMBI     H     S   fNA     N     I    II   III    IV     V
#>   <chr>   <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 1         4.5 0.918     2 0.333     6 0         0     0     1 0    
#> 2 2         4   1.51      3 0        15 0.333     0     0     0 0.667
#> # ℹ 1 more variable: Disturbance <chr>
#> 
#> $matched
#>   station              species      species_matched count group RA
#> 1       1 Acidostoma neglectum Acidostoma neglectum     2     0  0
#> 2       1   Acrocirrus validus   Acrocirrus validus     4     4  0
#> 3       2    Acteocina bullata    Acteocina bullata     5     1  0
#> 4       2  Austrohelice crassa  Austrohelice crassa     3     5  0
#> 5       2    Capitella nonatoi    Capitella nonatoi     7     5  0
#> 
#> $warnings
#> # A tibble: 3 × 2
#>   station warning                                                               
#>   <chr>   <chr>                                                                 
#> 1 1       The percentage of individuals not assigned to a group is higher than …
#> 2 1       The (not null) number of species is less than 3 [2].                  
#> 3 1       The (not null) number of individuals is less than 6 [4].              
#> 


# example (3) - conflict with AZTI species group

df_user <- data.frame(
              species = c("Cumopsis fagei"),
              group = c(1))

AMBI(test_data, by=c("station"), var_rep="replicate", df_species=df_user)
#> ℹ 1 user-assigned group in conflict with AMBI was ignored:
#> ✖ Cumopsis fagei (II)→(I)
#> 
#> $AMBI
#> # A tibble: 3 × 13
#>   station  AMBI AMBI_SD     H     S   fNA     N     I    II   III     IV      V
#>     <dbl> <dbl>   <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1       1  1.48   0.338  1.80     6     0    16 0.125 0.75  0.125 0      0     
#> 2       2  1.89   0.238  3.54    22     0    80 0.4   0.138 0.3   0.15   0.0125
#> 3       3  4.12   0.884  2.50     9     0    24 0     0.125 0.292 0.0833 0.5   
#> # ℹ 1 more variable: Disturbance <chr>
#> 
#> $AMBI_rep
#> # A tibble: 8 × 11
#>   station replicate  AMBI     S   fNA     N     I     II   III    IV      V
#>     <dbl> <chr>     <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>  <dbl>
#> 1       1 a          1.8      3     0     5 0     0.8    0.2   0     0     
#> 2       1 b          1.5      3     0     7 0.143 0.714  0.143 0     0     
#> 3       1 c          1.12     2     0     4 0.25  0.75   0     0     0     
#> 4       2 a          1.88    12     0    32 0.406 0.156  0.219 0.219 0     
#> 5       2 b          2.13    12     0    19 0.316 0.158  0.368 0.105 0.0526
#> 6       2 c          1.66    10     0    29 0.448 0.103  0.345 0.103 0     
#> 7       3 a          3.5      5     0     6 0     0.333  0.167 0.333 0.167 
#> 8       3 b          4.75     6     0    18 0     0.0556 0.333 0     0.611 
#> 
#> $matched
#> # A tibble: 53 × 9
#>    station replicate species species_matched count group source    RA group_note
#>      <dbl> <chr>     <chr>   <chr>           <dbl> <dbl> <chr>  <dbl> <chr>     
#>  1       1 a         Cumops… Cumopsis fagei      2     2 NA         0 ignored u…
#>  2       1 a         Diogen… Diogenes pugil…     2     2 NA         0 NA        
#>  3       1 a         Parado… Paradoneis arm…     1     3 NA         0 NA        
#>  4       1 b         Bathyp… Bathyporeia el…     1     1 NA         0 NA        
#>  5       1 b         Diogen… Diogenes pugil…     5     2 NA         0 NA        
#>  6       1 b         Dispio… Dispio uncinata     1     3 NA         0 NA        
#>  7       1 c         Astart… Astarte sp.         1     1 NA         0 NA        
#>  8       1 c         Diogen… Diogenes pugil…     3     2 NA         0 NA        
#>  9       2 a         Cumops… Cumopsis fagei      1     2 NA         0 ignored u…
#> 10       2 a         Glycer… Glycera tridac…     2     2 NA         0 NA        
#> # ℹ 43 more rows
#> 
```
