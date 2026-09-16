

ambi <- ambiR::AMBI(test_data_DK,
                    by = c("station"),
                    var_rep = "sample",
                    var_species = "species",
                    var_count="count",
                    quiet = TRUE)$AMBI


# DKI v2

test_that("DKI v2 (1)", {
  expect_equal(ambiR::DKI2(ambi$AMBI[1],ambi$H[1],  ambi$N[1], psal = 24.2 ), 0.9348461, tolerance=0.000001)
})

test_that("DKI v2 (2)", {
  expect_equal(ambiR::DKI2(ambi$AMBI[2],ambi$H[2],  ambi$N[2], psal = 24.2 ), 0.7688947, tolerance=0.000001)
})


# DKI v1

test_that("DKI v1 (1)", {
  expect_equal(ambiR::DKI(ambi$AMBI[1],ambi$H[1],  ambi$N[1], ambi$S[1], H_max = 5 ), 0.8187888, tolerance=0.000001)
})

test_that("DKI v1 (2)", {
  expect_equal(ambiR::DKI(ambi$AMBI[2],ambi$H[2],  ambi$N[2], ambi$S[2], H_max = 5 ), 0.6681702, tolerance=0.000001)
})

