test_that("save numbers in JSON works", {
    mydata <- 1:10
    filename <- tempfile()
    reproducibleRchunks:::save_repro_data(c("mydata"),
                                          filename = filename,
                                          filetype="json")

    test_envir <- new.env()
    reproducibleRchunks:::load_repro_data(filename, filetype="json",envir = test_envir)

    expect_that(ls(test_envir) == "mydata")
    expect_identical(get("mydata", envir=test_envir), mydata)

})

test_that("unknown filetype is caught", {
  mydata <- 1:10
  filename <- tempfile()
  expect_error(
    reproducibleRchunks:::save_repro_data("mydata", filename, "funnyfiletype")
  )
})
