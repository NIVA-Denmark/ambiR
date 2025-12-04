

version_names <- c("", "2024","2022")


for(version in version_names){
  title <- paste0("AMBI species ", version)

  test_that(title, {
    testthat::expect_no_error(ambiR::AMBI_species(version))
  })

}


test_that("Check duplicate species", {

  n <- ambiR::AMBI_species() %>%
    group_by(species) %>%
    summarise(n=n(), .groups="drop") %>%
    filter(n>1) %>%
    nrow()

  testthat::expect_equal(n, 0)

})


