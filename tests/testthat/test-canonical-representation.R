testthat::test_that("Canonical representation of hashes works",
{
df <- data.frame(x=c(1,2,3),y=c(4,5,6))
df2 <- df
attributes(df2) <- attributes(df2)[c(3,1,2)]

testthat::expect_equal(hash(df),hash(df2))
}
)

testthat::test_that("Canonical representation of hashes works in lists",
                    {
                      df <- data.frame(x=c(1,2,3),y=c(4,5,6))
                      df2 <- df
                      attributes(df2) <- attributes(df2)[c(3,1,2)]

                      x1 <- list(df, df)
                      x2 <- list(df, df2)

                      testthat::expect_equal(hash(x1),hash(x2))
                    }
)

testthat::test_that("Canonical representation of hashes works with rounding in lists",
                    {
                      x1 <- 0.0000000009
                      x2 <- 0.0000000007
                      testthat::expect_equal(hash(x1),hash(x2))
                      testthat::expect_false(identical(hash(x1,digits=FALSE),hash(x2,digits=FALSE)))
                    }
)
