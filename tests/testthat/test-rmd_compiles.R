test_that("RMD compiles and reproduces", {

  json_filename_chunk1 <- testthat::test_path("testdata",".repro_test_json.Rmd_somenumbers.json")
  if (file.exists(json_filename_chunk1)) {
    file.remove(json_filename_chunk1)
  }

  fname <- testthat::test_path("testdata","test_json.Rmd")
  foutname <- testthat::test_path("testdata","test_json.html")

  # create a fresh environment (to avoid that variables
  # defined in the Rmd file are already defined locally)
  envir <- new.env()
  knitr::knit(input=fname,output = foutname, envir = envir)

  testthat::expect_true(file.exists(foutname))

  testthat::expect_true(
    file.exists(json_filename_chunk1)
  )
})
