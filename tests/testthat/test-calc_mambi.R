

df1 <- data.frame(station = c(1, 1, 1, 2, 2, 2, 3, 3),
                 replicate = c("a", "b", "c", "a", "b", "c", "a", "b"),
                 AMBI = c(1.8, 1.5, 1.125, 1.875, 2.133, 1.655, 3.5, 4.75),
                 H = c(1.055, 0.796, 0.562, 2.072, 2.333, 1.789, 1.561, 1.303),
                 S = c(3, 3, 2, 12, 12, 10, 5, 6))

test_that("MAMBI", {
  res <- ambiR::MAMBI(df1)$MAMBI %>% sum()
  expect_equal(res, 5.7732192953883, tolerance=0.000001)
})

test_that("MAMBI with by variable", {
  res <- ambiR::MAMBI(df1, by = all_of(c("station")))$MAMBI %>% sum()
  expect_equal(res, 2.85433737037172, tolerance=0.000001)
})


