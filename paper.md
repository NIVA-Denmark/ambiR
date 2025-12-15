---
title: 'ambiR: an R package for calculating AMBI marine biotic index'
tags:
  - R
  - biotic index
  - ecological quality
  - benthos
  - European coastal environments
authors:
  - name: Ciarán J. Murray
    orcid: 0000-0003-0260-2008
    equal-contrib: true
    affiliation: "1, 2"
  - name: Sarai Pouso
    orcid: 0000-0003-3208-9882
    equal-contrib: true
    affiliation: 3
  - name: Iñigo Muxika
    orcid: 0000-0002-9181-3781
    equal-contrib: true
    affiliation: 3
  - name: Joxe Mikel Garmendia
    orcid: 0000-0002-9403-1777
    equal-contrib: true
    affiliation: 3    
  - name: Ángel Borja
    orcid: 0000-0003-1601-2025
    equal-contrib: true
    affiliation: 3
affiliations:
  - name: NIVA Denmark Water Research, Copenhagen, Denmark
    index: 1
  - name: Aquatic Synthesis Research Centre (AquaSYNC), Copenhagen, Denmark
    index: 2
  - name: AZTI, Marine Research, Basque Research and Technology Alliance (BRTA), Spain
    ror: 00jgbqj86
    index: 3 
date: 20 December 2025
bibliography: paper.bib

---

# Summary

Being able to assess the health of ecosystems and monitor response to changes
in pressures is key for their management. In coastal ecosystems, the species
composition of benthic invertebrate communities responds to pollution pressures:
the species most sensitive to pollution will be present only in pristine
conditions whilst domination by other opportunistic species groups is an
indication of a heavily polluted system.

The AZTI marine biotic index (AMBI) was developed to *"establish the ecological
quality of soft-bottom benthos within European estuarine and coastal
environments"* and presented in a paper by @BORJA20001100, which currently has
1291 citations in peer-reviwed articles (Web of Science, 11. December 2025). A
standalone program for calculating the AMBI index was developed as a Matlab®
distributable and made available free of charge by AZTI [@borja_biotic_2004]. It
has since has been widely used by students, other researchers and managers. The
R package `ambiR` allows the user to perform the same calculations as the
original AZTI software, including the multivariate M-AMBI index [@MUXIKA200716].

# Statement of need

R is used widely by researchers in biological and environmental sciences.
`ambiR` will allow students and researchers to incorporate AMBI and M-AMBI
calculations directly in an R workflow.The motivation for creating the `ambiR`
package began with attempts to calculate DKI in an R workflow. DKI (Dansk
Kvalitetsindeks) is a Danish benthic biotic index which essentially adjusts the
AMBI index to regions where relatively lower species diversity in pristine
conditions might be expected, for example where salinity levels are lower
[@carstensen_development_2014]. To calculate DKI, one must first calculate AMBI.
With the exception of the actual AMBI calculations, all other steps from input
data to performing analyses and plotting results could be carried out in R. To
calculate AMBI, observations have to be exported from R, imported to the AMBI
program and the results exported before being imported to R. The AMBI index is
already a well-established assessment methodology and the authors expect that
the ease with which the package allows users to reproduce AMBI calculations in R
will lead to a wide uptake. This will also improve reproducibility of analyses  
which include AMBI calculations.

# Features

AMBI functions:

* AMBI - the AZTI marine biotic index.
* M-AMBI - the multivariate index.
* DKI - The Danish benthic quality index.

auxiliary functions:

* H' - the Shannon diversity index.
* S - species richness.

A key feature of the original AMBI program is the included list of marine
species and genera which is used to match species names in observations to that
they can be assigned to one of the five AMBI categories, according to their
sensitivity to pollution pressures. The species list has been updated several
times by the authors and the most recent version from October 2024 contains
almost 12000 records. This species list is included in `ambiR`

The `test_data` dataset included in the package is identical to the example data
which accompanies the original program  with real examples of species count
observations from the Basque coast. Testing has ensured that the results from
`ambiR` are identical to those calculated by the AMBI program.

The package has an public GitHub repository
where users will be able to raise issues.


# Features

$\label{eq: eqnAMBI} Biotic\ Index = 0.0 · f_{I} + 1.5 · f_{II} + 3.0 · f_{III} + 4.5 · f_{IV} + 6.0 · f_V$

where:

$f_i$ = fraction of individuals in Group $i \in\{I, II, III, IV, V\}$

The multivariate *M-AMBI* method combines the `AMBI` index with *H'*, the Shannon
diversity index [@6773024], and `S`, the species richness[^1] to give an *ecological quality status* (EcoQS) index :

$EcoQS = K + a · AMBI + b · H' + c · S$

where:  $K$, $a$, $b$ and $c$ are determined by factorial analysis.

[^1]: the number of unique species in a sample

All required functionality is included in the package: `Hdash` `S` `MAMBI`

and refer to \autoref{eq:eqnAMBI} from text.


# Acknowledgements

Steen Knudsen created the artwork used in the ambiR logo.

Ángel Borja, Sarai Pouso, Iñigo Muxika and Joxe Mikel Garmendia received 
financial support from the HORIZON project GES4SEAS [^2]

[^2]: Grant Agreement 101059877 - GES4SEAS. The GES4SEAS project has been approved
under the HORIZON-CL6-2021-BIODIV-01-04 call: 'Assess and predict integrated
impacts of cumulative direct and indirect stressors on coastal and marine
biodiversity, ecosystems and their services'. Funded by the European Union.
Views and opinions expressed are however those of the authors only and do not
necessarily reflect those of the European Union or UK Research and Innovation.
Neither the European Union nor the granting authority can be held responsible
for them.



# References
