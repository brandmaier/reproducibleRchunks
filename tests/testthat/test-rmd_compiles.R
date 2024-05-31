test_that("RMD compiles and reproduces", {
  fname <- testthat::test_path("testdata","test_json.Rmd")
  foutname <- testthat::test_path("testdata","test_json.html")
  knitr::knit(input=fname,output = foutname)

  testthat::expect_true(file.exists(foutname))
})
