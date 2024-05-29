test_that("hash function reproduces on consecutive calls", {
  h1 <- reproducibleRchunks:::hash(c(1,2,3))
  h2 <- reproducibleRchunks:::hash(c(1,2,3))
  expect_identical(h1, h2)
})

test_that("hash function reproduces on consecutive calls", {
  options(reproducibleRchunks.hashing_algorithm="sha256")
  h1 <- reproducibleRchunks:::hash(c(1,2,3))
  expect_identical(h1, "2f36fd737fff4e4c313a930a84abeb8e0d137d78b897fe81fff5ad952c3a0c9a")

  options(reproducibleRchunks.hashing_algorithm="sha1")
  h1 <- reproducibleRchunks:::hash(c(1,2,3))
  expect_identical(h1, "6fdccc872a60a9170f5cb5eee74312f4cbc384af")

  options(reproducibleRchunks.hashing_algorithm="sha512")
  h1 <- reproducibleRchunks:::hash(c(1,2,3))
  expect_identical(h1,"f7afae95411d14936f2283b10cd3343222056400daef9aace2a889b8e8bad25f558df44b8da90cb77f7a9baf53563692ca9812cf38a2b8f5d92bb538126f174e")

  options(reproducibleRchunks.hashing_algorithm="md5")
  h1 <- reproducibleRchunks:::hash(c(1,2,3))
  expect_identical(h1,"af9e5c24af013c970922362b8850b060")

})
