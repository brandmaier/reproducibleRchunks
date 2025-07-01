test_that("mixing hashed and non-hashed JSON data works", {

  path <- testthat::test_path("testdata")
  fname <- "test2.Rmd"
  foutname <- "test2.pdf"


  lastwd <- getwd()
  setwd(normalizePath(path))

  knitr::knit(input=fname,output = foutname)

  testthat::expect_true(file.exists(foutname))

  setwd(lastwd)
})
