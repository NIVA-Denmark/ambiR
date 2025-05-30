
df1 <- data.frame(station = c("1","1","1","2","2","2"),
                  species = c("Cumopsis fagei",
                              "Diogenes pugilator",
                              "Paradoneis armata",
                              "Bathyporeia elegans",
                              "Diogenes pugilator",
                              "Dispio uncinata"),
                  count = c(2, 2, 1, 1, 5, 1))


test_that("AMBI with zeroes AMBI", {
  ambi <- ambiR::AMBI(df1)$AMBI
  expect_equal(ambi$AMBI, 1.625, tolerance=0.000001)
})

test_that("AMBI with zeroes S", {
  ambi <- ambiR::AMBI(df1)$AMBI
  expect_equal(ambi$S, 5)
})

df2 <- data.frame(station = c("1","1","1","2","2","2","2"),
                  species = c("Cumopsis fagei",
                              "Diogenes pugilator",
                              "Paradoneis armata",
                              "Bathyporeia elegans",
                              "Diogenes pugilator",
                              "Dispio uncinata",
                              "this is not a species"),
                 count = c(2, 2, 1, 1, 5, 1, 4))

test_that("AMBI with missing AMBI", {
  ambi <- ambiR::AMBI(df2)$AMBI
  expect_equal(ambi$AMBI, 1.625, tolerance=0.000001)
})

test_that("AMBI with missing S", {
  ambi <- ambiR::AMBI(df2)$AMBI
  expect_equal(ambi$S, 5)
})

df3 <- data.frame(species=c("Diastylis","Diastylis sp."),
                  count=c(2,2))

test_that("AMBI without exact name match", {
  n <- ambiR::AMBI(df3)$matched %>%
    filter(!is.na(group)) %>%
    nrow()
  expect_equal(n, 2)
})

test_that("AMBI with exact name match", {
  n <- ambiR::AMBI(df3, exact_species_match = T)$matched %>%
    filter(!is.na(group)) %>%
    nrow()
  expect_equal(n, 1)
})


