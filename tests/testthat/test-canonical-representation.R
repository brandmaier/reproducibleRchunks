testthat::test_that("Canonical representation of hashes works",
{
df <- data.frame(x=c(1,2,3),y=c(4,5,6))
df2 <- df
attributes(df2) <- attributes(df2)[c(3,1,2)]

testthat::expect_equal(hash(df),hash(df2))
}
)
