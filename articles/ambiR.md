# Get started

This is a brief introduction to AMBI index calculations with ambiR.

## Structuring species observation data

Species counts (or abundance) should be organized in a data frame
arranged in *long* format. That is, species names are in one column and
species counts in another column. If the data represents several
stations and/or if there are replicates, then the data should include
columns with this information.

Looking at the `test_data` example dataset included with the ambiR
package, one can see how the data should be arranged:

``` r
library(ambiR)

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

If your data look like this, you can go directly to [Calculate
AMBI](#calculate-ambi). If not, the following examples show how to
reorganize your data.

### Species names in columns

Here is an example dataframe where there are counts for species in
separate columns:

``` r
head(wide_data_species)
#> # A tibble: 6 × 36
#>   station replicate `Cumopsis fagei` `Diogenes pugilator` `Paradoneis armata`
#>     <dbl> <chr>                <dbl>                <dbl>               <dbl>
#> 1       1 a                        2                    2                   1
#> 2       1 b                        0                    5                   0
#> 3       1 c                        0                    3                   0
#> 4       2 a                        1                    0                   0
#> 5       2 b                        1                    0                   0
#> 6       2 c                        0                    0                   0
#> # ℹ 31 more variables: `Bathyporeia elegans` <dbl>, `Dispio uncinata` <dbl>,
#> #   `Astarte sp.` <dbl>, `Glycera tridactyla` <dbl>,
#> #   `Heteromastus filiformis` <dbl>, `Lekanesphaera hookeri` <dbl>,
#> #   `Melita palmata` <dbl>, `Nassarius reticulatus` <dbl>, Nemertea <dbl>,
#> #   `Prionospio fallax` <dbl>, `Scolaricia sp.` <dbl>,
#> #   `Spio martinensis` <dbl>, `Tapes decussatus` <dbl>, `Tellina sp.` <dbl>,
#> #   `Lekanesphaera rugicauda` <dbl>, `Lepidochitona cinerea` <dbl>, …
```

To arrange the data in the correct form, use
[`tidyr::pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html):

``` r
# columns 1 and 2 contain station and replicate information
# so, select all columns from 3 to be pivoted 

long_data <- wide_data_species %>%
  pivot_longer(cols = 3:ncol(wide_data_species), 
               names_to = "species",
               values_to = "count")

head(long_data)
#> # A tibble: 6 × 4
#>   station replicate species             count
#>     <dbl> <chr>     <chr>               <dbl>
#> 1       1 a         Cumopsis fagei          2
#> 2       1 a         Diogenes pugilator      2
#> 3       1 a         Paradoneis armata       1
#> 4       1 a         Bathyporeia elegans     0
#> 5       1 a         Dispio uncinata         0
#> 6       1 a         Astarte sp.             0
```

### Stations and replicates in columns

Here is an example where each column contains species counts for a
station and replicate. The first row of the table contains the station
ID *1, 2, …* and the second row contains the replicate ID *a, b, …*. The
first column of the table contains species names.

``` r
head(wide_data_stns)
#>                                      
#> 1                <NA> 1 1 1 2 2 2 3 3
#> 2                <NA> a b c a b c a b
#> 3      Cumopsis fagei 2 0 0 1 1 0 0 0
#> 4  Diogenes pugilator 2 5 3 0 0 0 0 0
#> 5   Paradoneis armata 1 0 0 0 0 0 0 0
#> 6 Bathyporeia elegans 0 1 0 0 0 0 0 0
```

Note that if the if the observation data *only* has stations *or*
replicates, then rearranging the data can be done in one step, as in the
[previous example](#data-with-species-names-in-columns). But in this
case, the station and replicate information are in separate rows. The
restructuring process is a little more complicated.

#### Combine station and replicate values

Before we can use a pivot function, we need to combine the station ID
and replicate ID for each column into a single value. In this example,
each station ID and replicate ID are joined into a single character
value, with an underscore to separate them *`_`*. The underscore will be
used again after pivoting the table to identify where to split the
combined station/replicate values back into separate values again.

If there are station names which already contain underscores, then
another suitable character should be used when joining and splitting
station/replicate IDs.

``` r
sep_character <- "_"

# get the station IDs from row 1, excluding column 1 (this contains species names)
stations <- wide_data_stns[1, 2:ncol(wide_data_stns)]

# get the replicate IDs from row 2
replicates <- wide_data_stns[2, 2:ncol(wide_data_stns)]

# combine the station and replicate for each column using an underscore
station_replicate <- paste(stations, replicates, sep=sep_character)

# now we have extracted the station/replicate information, we can drop the 
# first two rows of the data frame
wide_data_stns <- wide_data_stns[3:nrow(wide_data_stns),]

# apply the station_replicates as column names
names(wide_data_stns) <- c("species", station_replicate)

head(wide_data_stns)
#>               species 1_a 1_b 1_c 2_a 2_b 2_c 3_a 3_b
#> 3      Cumopsis fagei   2   0   0   1   1   0   0   0
#> 4  Diogenes pugilator   2   5   3   0   0   0   0   0
#> 5   Paradoneis armata   1   0   0   0   0   0   0   0
#> 6 Bathyporeia elegans   0   1   0   0   0   0   0   0
#> 7     Dispio uncinata   0   1   0   0   0   0   0   0
#> 8         Astarte sp.   0   0   1   0   0   0   0   0
```

#### Transpose using the combined station/replicate variable

We can see that the column names now contain the combined station and
replicate information. We are ready to transpose the data.

``` r
# column 1 contains species names
# so, select all columns from 2 to be pivoted 

long_data <- wide_data_stns %>%
  pivot_longer(cols = 2:ncol(wide_data_stns), 
               names_to = "stn_rep",
               values_to = "count")

head(long_data)
#> # A tibble: 6 × 3
#>   species        stn_rep count
#>   <chr>          <chr>   <chr>
#> 1 Cumopsis fagei 1_a     2    
#> 2 Cumopsis fagei 1_b     0    
#> 3 Cumopsis fagei 1_c     0    
#> 4 Cumopsis fagei 2_a     1    
#> 5 Cumopsis fagei 2_b     1    
#> 6 Cumopsis fagei 2_c     0
```

#### Retrieve station and replicate variables from the transposed data

Now we can split the *stn_rep* column into separate columns for
*station* and *replicate*, We will use the underscore we introduced
earlier to indentify where the split should occur:

``` r
long_data <- long_data %>%
  separate_wider_delim(cols="stn_rep", 
                       delim = sep_character,
                       names=c("station", "replicate"))

head(long_data)
#> # A tibble: 6 × 4
#>   species        station replicate count
#>   <chr>          <chr>   <chr>     <chr>
#> 1 Cumopsis fagei 1       a         2    
#> 2 Cumopsis fagei 1       b         0    
#> 3 Cumopsis fagei 1       c         0    
#> 4 Cumopsis fagei 2       a         1    
#> 5 Cumopsis fagei 2       b         1    
#> 6 Cumopsis fagei 2       c         0
```

Now we are ready to calculate AMBI…

## Calculate AMBI

We have now ensured that our species abundance/count data have the
correct structure, as in the example `test_data` provided:

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

Call the
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function:

``` r
res <- AMBI(test_data, by="station", var_rep="replicate", 
            var_species="species", var_count="count")
```

### Results

The [`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function returns a list of three dataframes:

- `.$AMBI`
- `.$AMBI_rep`
- `.$matched`

`.$AMBI`- the main results with the `AMBI` index calculated for each
unique combination of `by` variables, in our case the results are per
`station`.

In addition to the `AMBI` index, the results also include the *Shannon
diversity index* `H'` and the *Species richness* `S`, the three metrics
which are necessary to calculate [M-AMBI](#calculate-m-ambi).

``` r
res$AMBI
#> # A tibble: 3 × 13
#>   station  AMBI AMBI_SD     H     S   fNA     N     I    II   III     IV      V
#>     <dbl> <dbl>   <dbl> <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1       1  1.48   0.338  1.80     6     0    16 0.125 0.75  0.125 0      0     
#> 2       2  1.89   0.238  3.54    22     0    80 0.4   0.138 0.3   0.15   0.0125
#> 3       3  4.12   0.884  2.50     9     0    24 0     0.125 0.292 0.0833 0.5   
#> # ℹ 1 more variable: Disturbance <chr>
```

`.$AMBI_rep` - if the observations include replicates, then the function
also returns results calculated for each replicate, within each unique
combination of `by` variables:

``` r
res$AMBI_rep
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
```

`.$matched` - for each observation, this dataframe shows which species
in the `AMBI` list the observed species was matched with, if any. It
also shows the `AMBI` species group assigned. This dataframe has the
same number of rows as the input data.

``` r
head(res$matched)
#> # A tibble: 6 × 7
#>   station replicate species             species_matched     count group    RA
#>     <dbl> <chr>     <chr>               <chr>               <dbl> <dbl> <dbl>
#> 1       1 a         Cumopsis fagei      Cumopsis fagei          2     2     0
#> 2       1 a         Diogenes pugilator  Diogenes pugilator      2     2     0
#> 3       1 a         Paradoneis armata   Paradoneis armata       1     3     0
#> 4       1 b         Bathyporeia elegans Bathyporeia elegans     1     1     0
#> 5       1 b         Diogenes pugilator  Diogenes pugilator      5     2     0
#> 6       1 b         Dispio uncinata     Dispio uncinata         1     3     0
```

For more information about the principles underlying the `AMBI`
calculations and the grouping of species according to sensitivity to
pollution, see [about
AMBI](https://niva-denmark.github.io/ambiR/articles/about-AMBI.md)

## Calculate M-AMBI

Calculate M-AMBI the multivariate AMBI index, based on the three
separate species diversity metrics:

- AMBI index `AMBI`.
- Shannon diversity index `H`
- Species richness `S`.

All three indices required to calculate
[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)are
included in the results returned by the
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function.

### Limit values

In addition to index values calculated from observed species data, the
M-AMBI factor analysis requires values defining the limits for the three
metrics, corresponding to the best and worst possible conditions.

See Muxika, Borja, and Bald (2007) for more details.

The default limit values used by
[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)
are:

``` r
limits_AMBI <- c("bad" = 6, "high" = 0)

limits_H  <- c("bad" = 0, "high" = NA)

limits_S  <- c("bad" = 0, "high" = NA)
```

By default, upper limit values for `H` and `S` are not provided (`= NA`.
If they are not provided explicitly, then the maximum values found in
the input data will be used. The results returned by
[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)
show the limits used.

### Status class boundaries

[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)
also returns the status class (*Bad, Poor, Moderate, Good* or *High*)
for each M-AMBI index value. To do this, it compares the calculated
M-AMBI index value with values defining the boundaries between status
classes.

- `PB` - *Poor* / *Bad*
- `MP` - *Moderate* / *Poor*
- `GM` - *Good* / *Moderate*
- `HG` - *High* / *Good*

The default values for the class boundaries are:

``` r
bounds <-c("PB" = 0.2, "MP" = 0.39, "GM" = 0.53, "HG" = 0.77)
```

### Call `MAMBI()`

We call
[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)
using the previously generated `AMBI` results:

``` r
res_mambi <- MAMBI(res$AMBI, var_H = "H", var_S = "S", var_AMBI = "AMBI")
```

### M-AMBI results

In addition to retaining the values for `AMBI`. `H` and `S`, the results
include the following information:

- `x`, `y`, `z` - factor scores giving coordinates in the new factor
  space.
- `MAMBI` - the calculated M-AMBI index value
- `Status` - the status class for the M-AMBI index value
- `EQR` - the normalised [EQR](#eqr-values) index

The dataframe returned contains 2 more rows than the input data. Our
input data contained 3 rows (1 for each `station`). The results contain
5 rows. The 2 *additional* rows show the limit values for each of the
three metrics used in the M-AMBI caclulations.

``` r
res_mambi %>%
  select(station, AMBI, H, S, x, y, z, MAMBI, Status, EQR)
#> # A tibble: 5 × 10
#>   station  AMBI     H     S        x       y      z MAMBI Status   EQR
#>     <dbl> <dbl> <dbl> <dbl>    <dbl>   <dbl>  <dbl> <dbl> <chr>  <dbl>
#> 1       1  1.48  1.80     6  0.0366  -0.0556  0.584 0.518 Mod    0.467
#> 2       2  1.89  3.54    22 -0.246   -1.18   -1.78  0.893 High   0.907
#> 3       3  4.12  2.50     9 -0.00687  0.602   0.377 0.478 Mod    0.446
#> 4      NA  6     0        0  0.524    2.53    2.93  0     NA     0    
#> 5      NA  0     3.54    22 -0.308   -1.90   -2.11  1     NA     1
```

#### EQR values

As well as the status class, the function also returns a normalised
index value from 0 to 1 (*EQR*), calculated using the `bounds` boundary
values for the M-AMBI index. The following EQR values correspond to
status class boundaries:

- `0.2` - *Poor* / *Bad*
- `0.4` - *Moderate* / *Poor*
- `0.6` - *Good* / *Moderate*
- `0.8` \_ *High* / *Good*

For example, the M-AMBI value for station 3 is `0.478`. This lies
between the M-AMBI value corresponding to the *Moderate/Poor* status
class boundary (`"MP" = 0.39`) and the M-AMBI value corresponding to the
*Good/Moderate* status class boundary (`"GM" = 0.53`).

The normalised EQR value is given by linear interpolation:
$$EQR = 0.4 + (0.6 - 0.4)\frac{0.478 - 0.39}{0.53 - 0.39}$$

## References

Muxika, I, Á Borja, and J Bald. 2007. “Using Historical Data, Expert
Judgement and Multivariate Analysis in Assessing Reference Conditions
and Benthic Ecological Status, According to the European Water Framework
Directive.” *Marine Pollution Bulletin* 55 (1): 16–29.
<https://doi.org/10.1016/j.marpolbul.2006.05.025>.
