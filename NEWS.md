# ambiR (development version)

## Minor improvements and bug fixes

* `AMBI()` no longer fails due to occasional bug in using user-defined species lists (#38).

* diverse functions updated to avoid using deprecated features in tidyselect.
  - Using an external vector in selections was deprecated in tidyselect 1.1.0.
  - Using `all_of()` outside of a selecting function was deprecated in tidyselect 1.2.0. 

# ambiR 0.1.1

* CRAN release.

# ambiR 0.0.1

* Initial CRAN submission.
