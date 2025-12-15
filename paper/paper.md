---
title: 'ambiR: an R package for calculating the AMBI marine biotic index'
tags:
  - R
  - biotic index
  - ecological quality
  - benthos
  - European coastal environments
authors:
  - name: Ciarán J. Murray
    orcid: 0000-0003-0260-2008
    affiliation: "1, 2"
  - name: Sarai Pouso
    orcid: 0000-0003-3208-9882
    affiliation: 3
  - name: Iñigo Muxika
    orcid: 0000-0002-9181-3781
    affiliation: 3
  - name: Joxe Mikel Garmendia
    orcid: 0000-0002-9403-1777
    affiliation: 3    
  - name: Ángel Borja
    orcid: 0000-0003-1601-2025
    affiliation: 3
affiliations:
  - name: NIVA Denmark Water Research, Copenhagen, Denmark
    index: 1
  - name: Aquatic Synthesis Research Centre (AquaSYNC), Copenhagen, Denmark
    index: 2
  - name: AZTI, Marine Research, Basque Research and Technology Alliance (BRTA), Spain
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
1291 citations in peer-reviewed articles (Web of Science, 11. December 2025). A
standalone program for calculating the AMBI index was developed as a Matlab®
distributable and made available free of charge by AZTI
[@borja_biotic_2004;@Borja_2012_instructions]. It has since has been widely used
by students, other researchers and managers. The R package `ambiR` allows the
user to perform the same calculations as the original AZTI software, including
the multivariate M-AMBI index [@MUXIKA200716].

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
already a well-established assessment methodology for assessing ecological
status [@borja_forever_2019] and the authors expect that the ease with which the
package allows users to reproduce AMBI calculations in R will lead to a wide
uptake. This will also improve reproducibility of analyses which include AMBI
calculations.

# Features

The package allows the user to match species observations to lists of pollution 
sensitivity groups and calculate the key AMBI functions:

* AMBI - the AZTI marine biotic index.
* M-AMBI - the multivariate AMBI index.

The package also includes the auxiliary functions:

* DKI - The Danish benthic quality index (2 alternative versions).
* H' - the Shannon diversity index [@6773024].
* S - species richness, the number of unique species in a sample.

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

Full documentation of the package and AMBI index calculations can be found at
[https://niva-denmark.github.io/ambiR/](https://niva-denmark.github.io/ambiR/)
including vignettes demonstrating how to reproduce the style of figures generated
by the standalone AMBI program, `vignette("ambi-figures")`, and how to run the AMBI
index calculations in *interactive* mode, `vignette("interactive")`. 

The source code for the package is available in a public
[GitHub](https://github.com/NIVA-Denmark/ambiR) repository. Users can report
bugs or other issues regarding functionality and the label *'[Species
data](https://github.com/NIVA-Denmark/ambiR/issues?q=label%3A%22Species%20data%22)'*
can be assigned to notify the package maintainers about issues specifically
related to the AMBI species list and classification of species and genera
according to pollution sensitivity. These issues will be addressed in the
regular updates of the species list.

# Acknowledgements

Steen Knudsen
![](https://orcid.org/assets/vectors/orcid.logo.icon.svg){height="9pt"
valign="baseline" href="https://orcid.org/0000-0003-0428-9940"} created the
artwork used in the ambiR logo.

ÁB, SP, IM and JMG received support from the GES4SEAS project, approved under
the HORIZON-CL6-2021-BIODIV-01-04 call: 'Assess and predict integrated impacts
of cumulative direct and indirect stressors on coastal and marine biodiversity,
ecosystems and their services', Grant Agreement 101059877. Funded by the
European Union.

# References
