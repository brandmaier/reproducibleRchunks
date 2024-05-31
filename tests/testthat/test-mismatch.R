

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


