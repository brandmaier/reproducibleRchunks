test_that("potentially problematic variable names are stored correctly", {
  fname <- testthat::test_path("testdata","test3.Rmd")
  foutname <- testthat::test_path("testdata","test3.html")
  knitr::knit(input=fname,output = foutname)

  testthat::expect_true(file.exists(foutname))
})
