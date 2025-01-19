
test_that("AMBI_min 0", {
  expect_equal(ambiR::AMBI_sal(0), 3.083, tolerance=0.000001)
})

test_that("AMBI_min 27.7", {
  expect_equal(ambiR::AMBI_sal(27.7747), 8.3e-06, tolerance=0.000001)
})

test_that("AMBI_min 30", {
  expect_equal(ambiR::AMBI_sal(30), 0, tolerance=0.000001)
})

test_that("H_max 0", {
  expect_equal(ambiR::H_sal(0), 2.117, tolerance=0.000001)
})

test_that("H_max 30", {
  expect_equal(ambiR::H_sal(30), 4.697, tolerance=0.000001)
})


