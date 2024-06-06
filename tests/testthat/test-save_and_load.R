test_that("save numbers in JSON works", {
  # set no hashing
  options(reproducibleRchunks.hashing = FALSE)
  mydata <- 1:10
  filename <- tempfile()
  reproducibleRchunks::save_repro_data(c("mydata"),
                                        filename = filename,
                                        filetype = "json")

  test_envir <- new.env()
  reproducibleRchunks::load_repro_data(filename,
                                        filetype = "json",
                                        envir = test_envir)

  testthat::expect_identical(ls(test_envir), "mydata")
  testthat::expect_identical(get("mydata", envir = test_envir), mydata)

})

