library(R.matlab)
library(readxl)

#' these packages are not added to imports in package DESCRIPTION
#' they are required to prepare the species data included in the package
#' but are not needed to use the package


## ------- code to prepare AZTI species lists -------

res <- R.matlab::readMat("data-raw/20220531/library.mat")

date <- res$sldate[,1]
res <- res$specieslist
species <- res[[1]] %>%
  unlist()
names(species) <- NULL
group <- res[[2]][,1]
RA <- res[[3]][,1]

AZTI_species_list_20220531 <- data.frame(species, group, RA)

res <- R.matlab::readMat("data-raw/20241008/library.mat")

date <- res$sldate[,1]
res <- res$specieslist
species <- res[[1]] %>%
  unlist()
names(species) <- NULL
group <- res[[2]][,1]
RA <- res[[3]][,1]

# the newest version of the species list is just named species
AZTI_species_list <- data.frame(species, group, RA)

usethis::use_data(AZTI_species_list, AZTI_species_list_20220531, overwrite=TRUE, internal = TRUE)

## -------  test data set -------

test_data <- readxl::read_excel("data-raw/example_BDheader.xls")

test_data <- test_data %>%
  rename(station = Stations,
         replicate = Replicates,
         species = Species,
         count = Population)

usethis::use_data(test_data, overwrite=TRUE)


