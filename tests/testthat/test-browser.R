test_that("developers did not forget a browser() statement in the code", {
  all_func_names <- ls(getNamespace(testthat::testing_package()))
  func_bodies <- sapply(all_func_names, body)
  for (f in func_bodies) {
    testthat::expect_false(any(grepl(pattern = "browser\\(\\)", x=f)))
  }
})
