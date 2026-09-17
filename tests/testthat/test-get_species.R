

version_names <- c("", "2024","2022")


for(version in version_names){
  title <- paste0("AMBI species ", version)

  test_that(title, {
    testthat::expect_no_error(ambiR::AMBI_species(version))
  })

}

# Norwegian data
test_that("AMBINorwegian species data", {
  testthat::expect_no_error(ambiR::NO_species())
})


