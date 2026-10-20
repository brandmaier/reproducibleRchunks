# Details on Comparing Objects

## When are two objects the same?

To assess whether results were the same across reproduction attempts,
the `reproducibleRchunks` package stores selected results and compares
them to results once they are reproduced (i.e., when the R Markdown
document is rebuilt).

Object identity is either established by comparing their fingerprints,
that is, by default a SHA256 fingerprint, or the actual contents of an
object. To this end, the package uses
[`all.equal()`](https://rdrr.io/r/base/all.equal.html) from base R which
tests whether two objects are (nearly) equal. To test identity of two
objects, the function
[`identical()`](https://rdrr.io/r/base/identical.html) could be used.
However, identity is usually a too restrictive test. We expect that
different platforms with different processor architectures, different
system libraries and so on lead to slight numerical differences in
numerical results. Thus, the sameness of two objects is checked up to a
certain tolerance.

For example, the following code should return `TRUE` in both instances:

``` r
all.equal(5, 2+3)
```

    ## [1] TRUE

``` r
identical(5, 2+3)
```

    ## [1] TRUE

The following code will, depending on the platform not yield perfect
identity but should be (nearly) given the precision of the platform:

``` r
all.equal(1/1000000000*7, 0.000000007)
```

    ## [1] TRUE

``` r
identical(1/1000000000*7, 0.000000007)
```

    ## [1] FALSE

This is why the package uses
[`all.equal()`](https://rdrr.io/r/base/all.equal.html) whereas the
numerical precision can be set via options.

Further, when hashes are used, attributes of objects are compared in a
canonical form, in which their attributes are first sorted.
