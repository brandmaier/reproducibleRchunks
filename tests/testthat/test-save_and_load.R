test_that("save numbers in JSON works", {
  mydata <-- 1:10
  filename <- tempfile()
  reproducibleRchunks::save_repro_data(c("mydata"),
                                        filename = filename,
                                        filetype = "json")

  test_envir <- new.env()
  reproducibleRchunks::load_repro_data(filename,
                                        filetype = "json",
                                        envir = test_envir)

  expect_that(ls(test_envir) == "mydata")
  expect_identical(get("mydata", envir = test_envir), mydata)

})

test_that("unknown objects are caught", {
  if (exists("xxx"))
    rm("xxx")
  filename <- tempfile()
  expect_error(reproducibleRchunks:::save_repro_data(c("xxx"),
                                                     filename = filename,
                                                     filetype = "json"))
})

test_that("unknown filetype is caught", {
  mydata <- 1:10
  filename <- tempfile()
  expect_error(reproducibleRchunks::save_repro_data("mydata",
                                                     filename,
                                                     "funnyfiletype"))
})

test_that("mismatch between hash options of stored data and defaults are caught",
          {
            options(reproducibleRchunks.hashing_algorithm = "sha256")
            mydata <- 1:10
            cat("\nTADATA ",exists("mydata"),"\n\n")
            filename <- tempfile()
            reproducibleRchunks::save_repro_data(c("mydata"),
                                                  filename = filename,
                                                  filetype = "json")

            test_envir <- new.env()
            options(reproducibleRchunks.hashing_algorithm = "sha512")
            reproducibleRchunks::load_repro_data(filename,
                                                  filetype = "json",
                                                  envir = test_envir)

            expect_that(ls(test_envir) == "mydata")
            expect_identical(get("mydata", envir = test_envir), mydata)
            #// TODO  - unfinished

          })


