test_that("potentially problematic variable names are stored correctly", {
  path <- testthat::test_path("testdata")
  fname <- "test3.Rmd"
  foutname <- "test3.html"
  lastwd <- getwd()
  setwd(normalizePath(path))
  knitr::knit(input=fname,output = foutname)
  testthat::expect_true(file.exists(foutname))
  setwd(lastwd)

  if (file.exists(foutname)) unlink(foutname)
})
