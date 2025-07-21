test_that("reset deletes reproducibility files", {
  tmp <- tempfile()
  dir.create(tmp)
  oldwd <- setwd(tmp)
  on.exit(setwd(oldwd), add = TRUE)

  prefix <- default_prefix()
  filetype <- default_filetype()

  f1 <- file.path(tmp, paste0(prefix, "_test1.", filetype))
  f2 <- file.path(tmp, paste0(prefix, "_test2.", filetype))
  file.create(f1)
  file.create(f2)

  expect_true(all(file.exists(c(f1, f2))))

  reproducibleRchunks::reset()

  expect_false(any(file.exists(c(f1, f2))))
})
