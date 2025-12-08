# The AMBI index

## The AMBI index

The basis of the AMBI index is that soft-bottom macrofauna are divided
into groups according to their sensitivity to increasing environmental
stress. The distribution of counts of individuals or relative abundance
between the different groups is used to calculate a quantitative measure
of the ecological quality of the benthic environment.

### Species Groups

Input to the
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function is a dataframe of species counts with optional grouping
variables, e.g. station or replicate IDs. The function matches species
names in the input data with names in the AMBI species list, in order to
categorise the observed species according to the AMBI method. The tool
then calculates the *AMBI* index resulting from the distribution of
individuals between the groups.

The AMBI species list gives the groups (I, II, III, IV, V) in which each
species is classified, as described by Borja, Franco, and Pérez (2000).

- *Group I*  
  Species very sensitive to organic enrichment and present under
  unpolluted conditions (initial state). They include the specialist
  carnivores and some deposit- feeding *tubicolous polychaetes*.
- *Group II*  
  Species indifferent to enrichment, always present in low densities
  with non-significant variations with time (from initial state, to
  slight unbalance). These include suspension feeders, less selective
  carnivores and scavengers.
- *Group III*  
  Species tolerant to excess organic matter enrichment. These species
  may occur under normal conditions, but their populations are
  stimulated by organic enrichment (slight unbalance situations). They
  are surface deposit-feeding species, as *tubicolous spionids*.
- *Group IV*  
  Second-order opportunistic species (slight to pronounced unbalanced
  situations). Mainly small sized *polychaetes*: subsurface
  deposit-feeders, such as *cirratulids*.
- *Group V*  
  First-order opportunistic species (pronounced unbalanced situations).
  These are deposit- feeders, which proliferate in reduced sediments.

The list of species and their groups has been updated several times by
the authors of the AMBI software. The version of the list used here is
from 8. October 2024.

After calculating the fractions $f_{i}$ of all individuals belonging to
each group $i \in {}I,II,III,IV,V$, then the index is given by:

$$AMBI = 0*f_{I} + 1.5*f_{II} + 3*f_{III} + 4.5*f_{IV} + 6*f_{V}$$

So, the greater the proportion of sensitive species, the lower the
resulting AMBI index. A sample consisting 100% of species from the most
sensitive category (Group I) will have an AMBI index of 0.0. A
population consisting entirely of species from Group V will have an
index of 6.0.

## M-AMBI - the multivariate AMBI index

[`MAMBI()`](https://niva-denmark.github.io/ambiR/reference/MAMBI.md)
calculates M-AMBI the multivariate AMBI index, based on the three
separate species diversity metrics:

- AMBI index *AMBI*
- Shannon Wiener diversity index *H’*
- Species richness *S*

The principles of the M-AMBI index are described by Muxika, Borja, and
Bald (2007)

*“AMBI, richness and diversity, combined with the use, in a further
development, of factor analysis together with discriminant analysis, is
presented as an objective tool (named here M-AMBI) in assessing
ecological quality status”*

It is, of course, possible to calculate M-AMBI using data generated in
other analyses, outside the {ambiR} package but the
[`AMBI()`](https://niva-denmark.github.io/ambiR/reference/AMBI.md)
function can conveniently provide all 3 of the metrics used as variables
in the M-AMBI factorial analysis.

- from the input data with values of *AMBI*, *H’* and *S*, the variables
  are first standardized, by subtracting by the mean and then dividing
  by the standard deviation.

- the analysis requires information on limits for each of the 3
  variables: *(a)* values corresponding to *reference* or *undisturbed*
  conditions. For the Shannon diversity *H’* and species richness *S*,
  these are taken as the maximum values found in the data. This assumes
  that some of the observations are from *undisturbed* sites so care
  should be given and suitable values provided by the user if this
  assumption does not hold. For *AMBI*, the reference condition value
  used is `0`, unless a different value is specified. *(b)* default
  limit values corresponding to *bad* conditions are `AMBI = 6`, `H = 0`
  and `S = 0`.

- factor analysis (FA) using the principal component analysis method on
  the standardized variables generates 3 factors.

- the Varimax rotation method is applied to the results of FA. The
  factor scores (`x`, `y` and `z`) are the new coordinates of each
  sampling station in the new factor space.

- These coordinates are used to derive the EQR or M-AMBI values. The
  M-AMBI score is the mean of the distance along the zero to one scale
  in the three dimensions. Depending on specific regional conditions the
  M-AMBI value corresponding to the Good/Moderate and other class
  boundaries can be used to convert M-AMBI values to a normalised EQR
  value where the Good/Moderate boundary is at EQR = 0.6.

## AMBI software

The AMBI software was developed as a free standalone software to allow
users to perform AMBI index calculations. Later versions were updated to
include the multivariate index M-AMBI calculations and adjustments to
the species list used to assign species to ecological groups. The
software is maintained and updated by
[AZTI](https://www.azti.es/en/?s=AMBI), where the latest version can be
downloaded.

The ambiR package has been extensively tested and gives identical
results to the AMBI software, as long as the version of species list
select corresponds to the to the version used by the software.

## References

Borja, Á, J Franco, and V Pérez. 2000. “A Marine Biotic Index to
Establish the Ecological Quality of Soft-Bottom Benthos Within European
Estuarine and Coastal Environments.” *Marine Pollution Bulletin* 40
(12): 1100–1114. <https://doi.org/10.1016/S0025-326X(00)00061-8>.

Muxika, I, Á Borja, and J Bald. 2007. “Using Historical Data, Expert
Judgement and Multivariate Analysis in Assessing Reference Conditions
and Benthic Ecological Status, According to the European Water Framework
Directive.” *Marine Pollution Bulletin* 55 (1): 16–29.
<https://doi.org/10.1016/j.marpolbul.2006.05.025>.
