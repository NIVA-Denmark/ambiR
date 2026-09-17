library(R.matlab)
library(readxl)
library(dplyr)

#' these packages are not added to imports in package DESCRIPTION
#' they are required to prepare the species data included in the package
#' but are not needed to use the package


## ------- code to prepare AZTI species lists -------

# version 2014

res <- readxl::read_excel("data-raw/20141113/AMBI_specieslist_13-nov-2014.xlsx")

AMBI_species_list_20141113 <- res %>%
  select(species= `Name (AMBI)`, group=`Ecological group (AMBI)`)

AMBI_species_list_20141113$RA <- NA


# version 2017

res <- R.matlab::readMat("data-raw/20170605/library.mat")

date <- res$sldate[,1]
res <- res$specieslist
species <- res[[1]] %>%
  unlist()
names(species) <- NULL
group <- res[[2]][,1]
# RA <- res[[3]][,1]

species[5201]

AMBI_species_list_20170605 <- data.frame(species, group)

AMBI_species_list_20170605[5201,1 ] <- stringr::str_replace(AMBI_species_list_20170605[5201,1 ], "\xff", " ")

AMBI_species_list_20170605$RA <- NA


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

x <- AMBI_species_list_20220531 %>%
  filter(stringr::str_detect(species, "[^[:space:]]sp\\."))

AMBI_species_list_20220531 <- AMBI_species_list_20220531 %>%
  mutate(species = stringr::str_replace(species, "Neorhynchoplaxsp.", "Neorhynchoplax sp.")) %>%
  mutate(species = stringr::str_replace(species, "Valenciniasp.", "Valencinia sp."))


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


x <- AMBI_species_list_20241008 %>%
  filter(stringr::str_detect(species, "[^[:space:]]sp\\."))

AMBI_species_list_20241008 <- AMBI_species_list_20241008 %>%
  mutate(species = stringr::str_replace(species, "Neorhynchoplaxsp.", "Neorhynchoplax sp.")) %>%
  mutate(species = stringr::str_replace(species, "Valenciniasp.", "Valencinia sp."))


# usethis::use_data(AMBI_species_list_20241008,
#                   AMBI_species_list_20220531,
#                   overwrite=TRUE, internal = TRUE)

write.table(AMBI_species_list_20241008, file = "data-raw/AMBI_species_list.csv", sep=",", row.names=F)


## -------  Norwegian species sensitivities -------
# used for NSI() and ISI()
NO_species_file <- "data-raw/Sensitivitetsverdier for NSI2018 og ISI 2018_13.11.2024.xlsx"
readxl::excel_sheets(NO_species_file)
NO_species_list <- readxl::read_excel(NO_species_file, sheet=2) #"Sens-verdier 2012+18, økol.gr")

NO_species_list <- NO_species_list %>%
  rename(species=Takson_navn,
         group_AMBI = `AMBI EG`,
         group_NSI = `NSI "EG"`,
         group_ISI = `ISI "EG"`) %>%
  mutate(group_AMBI=as.numeric(group_AMBI))

# usethis::use_data(NO_species_list, overwrite=TRUE, internal = TRUE)

usethis::use_data(AMBI_species_list_20241008,
                  AMBI_species_list_20220531,
                  AMBI_species_list_20170605,
                  AMBI_species_list_20141113,
                  NO_species_list,
                  overwrite=TRUE, internal = TRUE)


## -------  test data sets -------

# AMBI
test_data <- readxl::read_excel("data-raw/example_BDheader.xls")

test_data <- test_data %>%
  rename(station = Stations,
         replicate = Replicates,
         species = Species,
         count = Population)

usethis::use_data(test_data, overwrite=TRUE)

# DK

test_data_DK <- readRDS("data-raw/test-DK.Rds")  %>%
  select(station=ObservationsStedNavn,
         sample=Prøvetagningsnummer,
         species=Artsnavn,
         count=Antal)

usethis::use_data(test_data_DK, overwrite=TRUE)

# NO

test_data_NO <- readRDS("data-raw/test-NO.Rds") %>%
  select(station=Vannlokalitetsnavn,
         sample=Provenr,
         species=VitenskapligNavn,
         count=Verdi)

usethis::use_data(test_data_NO, overwrite=TRUE)


