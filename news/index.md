# Changelog

## ambiR 0.1.0

- Initial CRAN submission.

Includes a new version of the AMBI species list (2025-12-05). This has
some minor corrections to the list supplied with the latest software
version (2024-10-08). Five species had duplicate entries:

- *Macrophthalmus (Macrophthalmus) sulcatus*  
- *Ophiuroidea*  
- *Parheteromastus tenuis*  
- *Proclea graffii*  
- *Sabatieria elongata*

The duplicate rows have been removed. For *Ophiuroidea*, the two
versions had different values for `RA`, indicating whether or not the
species category can be reallocated (`0` No, `1` Yes). The version
retained is `RA = 1`. For the 4 other species, both versions had the
same `group`and `RA`.
