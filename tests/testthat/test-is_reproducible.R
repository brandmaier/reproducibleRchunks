test_that("isReproducible returns TRUE on test_json.Rmd", {
  rmd <- testthat::test_path("testdata", "test_json.Rmd")
  html <- testthat::test_path("testdata", "test_json.html")
  json <- testthat::test_path("testdata", ".repro_test_json.Rmd_somenumbers.json")

  if (file.exists(html)) file.remove(html)
  if (file.exists(json)) file.remove(json)

  on.exit({
    if (file.exists(html)) file.remove(html)
    if (file.exists(json)) file.remove(json)
  }, add = TRUE)

  # render once
  rmarkdown::render(input = rmd, quiet = TRUE)

  # render twice
  res <- reproducibleRchunks::isReproducible(rmd)
  expect_true(res)
})
