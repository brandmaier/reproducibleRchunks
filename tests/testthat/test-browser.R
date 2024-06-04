test_that("developers did not forget a browser() statement in the code", {
  funcs <- c(reproducibleRchunks::reproducibleR, reproducibleRchunks::save_repro_data,
             reproducibleRchunks::load_repro_data)
  for (f in funcs) {
    f_source <- deparse(f)
    testthat::expect_false(any(grepl(pattern = "browser\\(\\)", x=f_source)))
  }
})
