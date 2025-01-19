
df1 <- data.frame(station = c("1","1","1","2","2","2"),
                  species = c("Acidostoma neglectum",
                              "Acar botanica",
                              "Acrocirrus validus",
                              "Acteocina bullata",
                              "Austrohelice crassa",
                              "Capitella nonatoi"),
                  count = c(1, 2, 4, 5, 3, 7))


test_that("H' with zeroes H", {
  H <- ambiR::Hdash(df1)$H
  expect_equal(round(H$H, 6), 2.367795)
})

test_that("H' with zeroes N", {
  H <- ambiR::Hdash(df1)$H
  expect_equal(H$N, 22)
})

df2 <- data.frame(station = c("1","1","1","2","2","2","2"),
                 species = c("Acidostoma neglectum",
                             "Acar botanica",
                             "Acrocirrus validus",
                             "Acteocina bullata",
                             "Austrohelice crassa",
                             "Capitella nonatoi",
                             "this is not a species"),
                 count = c(1, 2, 4, 5, 3, 7, 4))

test_that("H' with missing H", {
  H <- ambiR::Hdash(df2)$H
  expect_equal(round(H$H, 6), 2.367795)
})

