library(R.matlab)
library(readxl)
library(dplyr)

#' these packages are not added to imports in package DESCRIPTION
#' they are required to prepare the species data included in the package
#' but are not needed to use the package


## ------- code to prepare AZTI species lists -------

# version 2022

res <- R.matlab::readMat("data-raw/20220531/library.mat")

date <- res$sldate[,1]
res <- res$specieslist
species <- res[[1]] %>%
  unlist()
names(species) <- NULL
group <- res[[2]][,1]
RA <- res[[3]][,1]

AMBI_species_list_20220531 <- data.frame(species, group, RA)

# version 2024

res <- R.matlab::readMat("data-raw/20241008/library.mat")

date <- res$sldate[,1]
res <- res$specieslist
species <- res[[1]] %>%
  unlist()
names(species) <- NULL
group <- res[[2]][,1]
RA <- res[[3]][,1]

AMBI_species_list_20241008 <- data.frame(species, group, RA)

# the newest version of the species list is just named species

# version 2025
AMBI_species_list_20251205 <- AMBI_species_list_20241008

AMBI_species_list_20251205 <- AMBI_species_list_20251205 %>%
  group_by(species, group) %>%
  arrange(desc(RA)) %>%
  slice(1) %>%
  ungroup()

usethis::use_data(AMBI_species_list_20251205,
                  AMBI_species_list_20241008,
                  AMBI_species_list_20220531,
                  overwrite=TRUE, internal = TRUE)


write.table(AMBI_species_list_20251205, file = "data-raw/AMBI_species_list.csv", sep=",", row.names=F)

## -------  test data set -------

test_data <- readxl::read_excel("data-raw/example_BDheader.xls")

test_data <- test_data %>%
  rename(station = Stations,
         replicate = Replicates,
         species = Species,
         count = Population)

usethis::use_data(test_data, overwrite=TRUE)


