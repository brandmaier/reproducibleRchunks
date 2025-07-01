# reproducibleRchunks 1.1.0

* Rewrite of the internal evaluation and formatting engine to relay most of the heavy
lifting to knitrs native code; this enables support of all standard code chunk options that
were previously not supported, including the creation of figures
* In the reproducibility report, a warning is now displayed if a reproducibleR chunk has no newly declared variables and thus has no actual reproducibility checks

# reproducibleRchunks 1.0.3

* New function `isReproducible()` allows checking whether a given R Markdown file reproduces or not
* Package metadata now contains comprehensive information about R version
* Reproducibility information is now stored in an internal environment called `.cache`
* This is the package version that was descried in the paper Automated Reproducibility Testing in R Markdown (2025) by Brandmaier and Peikert.

# reproducibleRchunks 1.0.2

* Removed global environment references according to CRAN policy
* Improved documentation with more descriptions and return values
* Removed usage of installed.packages() according to CRAN policy
* Object comparisons are now made via `all.equal()` instead of `identical()`

# reproducibleRchunks 1.0.1

* Added a `NEWS.md` file to track changes to the package.
