
# NQI

ambi <- ambiR::AMBI(test_data_NO,
                    by = c("station"),
                    var_rep = "sample",
                    var_species = "species",
                    var_count="count",
                    quiet = TRUE)$AMBI


test_that("NQI1 (1)", {
  expect_equal(ambiR::NQI1(ambi$AMBI[1], ambi$N[1], ambi$S[1]), 0.855328, tolerance=0.000001)
})

test_that("NQI1 (2)", {
  expect_equal(ambiR::NQI1(ambi$AMBI[2], ambi$N[2], ambi$S[2]), 0.7642318, tolerance=0.000001)
})

# NSI

nsi <- ambiR::NSI(test_data_NO,
                  by = c("station"),
                  var_species = "species",
                  var_count="count")$NSI

test_that("NSI (1)", {
  expect_equal(nsi$NSI2018[1], 29.1159, tolerance=0.000001)
})


test_that("NSI (2)", {
  expect_equal(nsi$NSI2018[2], 24.51539, tolerance=0.000001)
})


nsi2012 <- ambiR::NSI(test_data_NO,
                      by = c("station"),
                      var_species = "species",
                      var_count="count",
                      version = "2012")$NSI


test_that("NSI2012 (1)", {
  expect_equal(nsi2012$NSI2012[1], 26.46436, tolerance=0.000001)
})


test_that("NSI2012 (2)", {
  expect_equal(nsi2012$NSI2012[2], 22.25072, tolerance=0.000001)
})


# ISI

isi <- ambiR::ISI(test_data_NO,
                  by = c("station"),
                  var_species = "species"
                  )$ISI

test_that("ISI (1)", {
  expect_equal(isi$ISI2018[1], 7.309118 , tolerance=0.000001)
})


test_that("ISI (2)", {
  expect_equal(isi$ISI2018[2], 6.794207, tolerance=0.000001)
})


isi2012 <- ambiR::ISI(test_data_NO,
                      by = c("station"),
                      var_species = "species",
                      version = "2012")$ISI


test_that("ISI2012 (1)", {
  expect_equal(isi2012$ISI2012[1], 9.358061, tolerance=0.000001)
})


test_that("ISI2012 (2)", {
  expect_equal(isi2012$ISI2012[2], 9.542577, tolerance=0.000001)
})



