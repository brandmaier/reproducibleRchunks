test_that("mixing hashed and non-hashed JSON data works", {
  fname <- testthat::test_path("testdata","test2.Rmd")
  foutname <- testthat::test_path("testdata","test2.pdf")
  knitr::knit(input=fname,output = foutname)

  testthat::expect_true(file.exists(foutname))
})
